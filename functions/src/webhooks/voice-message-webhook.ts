/**
 * Webhook obsługi wiadomości głosowych (WhatsApp/Messenger/SMS MMS)
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {TwilioProvider} from "../providers/twilio-provider";
import {ASRProvider} from "../providers/asr-provider";
import {TTSProvider} from "../providers/tts-provider";
import {ConversationOrchestrator} from "../services/conversation-orchestrator";

const twilioAccountSid = process.env.TWILIO_ACCOUNT_SID || "";
const twilioAuthToken = process.env.TWILIO_AUTH_TOKEN || "";
const twilioFromNumber = process.env.TWILIO_FROM_NUMBER || "";

/**
 * Webhook dla wiadomości głosowych
 * POST /webhooks/voiceMessage
 */
export const voiceMessageWebhook = functions.https.onRequest(async (req, res) => {
  try {
    // Tylko POST
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const {MessageSid, From, MediaUrl0, MediaContentType0} = req.body;

    // Walidacja
    if (!MessageSid || !From || !MediaUrl0) {
      res.status(400).send("Missing required fields");
      return;
    }

    // Deduplication - sprawdź czy już przetwarzaliśmy tę wiadomość
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
      type: "voice",
    });

    // Inicjalizuj providery
    const twilioProvider = new TwilioProvider(twilioAccountSid, twilioAuthToken, twilioFromNumber);
    const asrProvider = new ASRProvider();
    const ttsProvider = new TTSProvider();
    const orchestrator = new ConversationOrchestrator(db);

    // Pobierz audio z URL
    console.log(`Downloading audio from ${MediaUrl0}`);
    const audioBuffer = await twilioProvider.getMediaContent(MediaUrl0);

    // Transkrypcja audio -> tekst (ASR)
    console.log(`Transcribing audio (${MediaContentType0})`);
    const transcription = await asrProvider.transcribe(audioBuffer, MediaContentType0);
    console.log(`Transcription: ${transcription}`);

    if (!transcription || transcription.trim().length === 0) {
      await twilioProvider.sendSMS(From, "Przepraszam, nie usłyszałem wyraźnie. Spróbuj ponownie.");
      res.status(200).send("OK");
      return;
    }

    // Przetwórz przez orchestrator
    const sessionId = `session-${From.replace(/\+/g, "")}`;
    const response = await orchestrator.processMessage(sessionId, transcription);

    // Generuj odpowiedź głosową (TTS)
    console.log(`Generating TTS response`);
    const audioResponse = await ttsProvider.synthesize(response);

    // Opcjonalnie: Upload audio do storage i wyślij URL
    // Dla uproszczenia MVP - wyślij jako tekst
    await twilioProvider.sendSMS(From, response);

    res.status(200).send("OK");
  } catch (error) {
    console.error("Error processing voice message:", error);
    res.status(500).send("Internal Server Error");
  }
});
