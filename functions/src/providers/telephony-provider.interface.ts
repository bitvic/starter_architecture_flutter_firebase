/**
 * Interfejs providera telefonii (Twilio/Vonage/Telnyx)
 */

import {TelephonyMessage, TelephonyResponse} from "../types";

export interface ITelephonyProvider {
  /**
   * Wysyła wiadomość SMS
   */
  sendSMS(to: string, message: string): Promise<TelephonyResponse>;

  /**
   * Pobiera zawartość wiadomości medialnej (głosówka)
   */
  getMediaContent(mediaUrl: string): Promise<Buffer>;

  /**
   * Wysyła wiadomość MMS z nagraniem audio
   */
  sendMMS(to: string, message: string, mediaUrl: string): Promise<TelephonyResponse>;
}
