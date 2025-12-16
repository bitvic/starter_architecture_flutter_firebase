/**
 * Webhook obsługi SMS tekstowych
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {TwilioProvider} from "../providers/twilio-provider";
import {ConversationOrchestrator} from "../services/conversation-orchestrator";

const twilioAccountSid = process.env.TWILIO_ACCOUNT_SID || "";
const twilioAuthToken = process.env.TWILIO_AUTH_TOKEN || "";
const twilioFromNumber = process.env.TWILIO_FROM_NUMBER || "";

/**
 * Webhook dla SMS tekstowych
 * POST /webhooks/sms
 */
export const smsWebhook = functions.https.onRequest(async (req, res) => {
  try {
    // Tylko POST
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const {MessageSid, From, Body} = req.body;

    // Walidacja
    if (!MessageSid || !From || !Body) {
      res.status(400).send("Missing required fields");
      return;
    }

    // Deduplication
    const db = admin.firestore();
    const processedRef = db.collection("processedMessages").doc(MessageSid);
    const processedDoc = await processedRef.get();

    if (processedDoc.exists) {
      console.log(`Message ${MessageSid} already processed`);
      res.status(200).send("OK - already processed");
      return;
    }

    // Oznacz jako przetworzone
    await processedRef.set({
      messageId: MessageSid,
      from: From,
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
      type: "sms",
      body: Body,
    });

    // Inicjalizuj providery
    const twilioProvider = new TwilioProvider(twilioAccountSid, twilioAuthToken, twilioFromNumber);
    const orchestrator = new ConversationOrchestrator(db);

    // Przetwórz wiadomość
    const sessionId = `session-${From.replace(/\+/g, "")}`;
    console.log(`Processing SMS from ${From}: ${Body}`);
    const response = await orchestrator.processMessage(sessionId, Body);

    // Wyślij odpowiedź
    await twilioProvider.sendSMS(From, response);

    res.status(200).send("OK");
  } catch (error) {
    console.error("Error processing SMS:", error);
    res.status(500).send("Internal Server Error");
  }
});
