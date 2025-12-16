/**
 * Implementacja providera Twilio
 */

import * as twilio from "twilio";
import {ITelephonyProvider} from "./telephony-provider.interface";
import {TelephonyResponse} from "../types";
import * as https from "https";

export class TwilioProvider implements ITelephonyProvider {
  private client: twilio.Twilio;
  private fromNumber: string;

  constructor(accountSid: string, authToken: string, fromNumber: string) {
    this.client = twilio(accountSid, authToken);
    this.fromNumber = fromNumber;
  }

  async sendSMS(to: string, message: string): Promise<TelephonyResponse> {
    try {
      const result = await this.client.messages.create({
        body: message,
        from: this.fromNumber,
        to: to,
      });

      return {
        success: true,
        messageId: result.sid,
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.message,
      };
    }
  }

  async getMediaContent(mediaUrl: string): Promise<Buffer> {
    return new Promise((resolve, reject) => {
      https.get(mediaUrl, (res) => {
        const chunks: Buffer[] = [];
        res.on("data", (chunk) => chunks.push(chunk));
        res.on("end", () => resolve(Buffer.concat(chunks)));
        res.on("error", reject);
      });
    });
  }

  async sendMMS(to: string, message: string, mediaUrl: string): Promise<TelephonyResponse> {
    try {
      const result = await this.client.messages.create({
        body: message,
        from: this.fromNumber,
        to: to,
        mediaUrl: [mediaUrl],
      });

      return {
        success: true,
        messageId: result.sid,
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.message,
      };
    }
  }
}
