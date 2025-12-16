/**
 * Provider dla Google Cloud Text-to-Speech (TTS)
 */

import {TextToSpeechClient} from "@google-cloud/text-to-speech";

export class TTSProvider {
  private client: TextToSpeechClient;

  constructor() {
    this.client = new TextToSpeechClient();
  }

  /**
   * Konwertuje tekst na mowę
   * @param text Tekst do syntezy
   * @return URL do pliku audio lub Buffer
   */
  async synthesize(text: string): Promise<Buffer> {
    const request = {
      input: {text: text},
      voice: {
        languageCode: "pl-PL",
        name: "pl-PL-Wavenet-A", // Głos żeński
        ssmlGender: "FEMALE" as const,
      },
      audioConfig: {
        audioEncoding: "MP3" as const,
      },
    };

    try {
      const [response] = await this.client.synthesizeSpeech(request);
      if (!response.audioContent) {
        throw new Error("Brak zawartości audio w odpowiedzi TTS");
      }
      return Buffer.from(response.audioContent as Uint8Array);
    } catch (error) {
      console.error("Błąd syntezy TTS:", error);
      throw new Error("Nie udało się wygenerować odpowiedzi głosowej.");
    }
  }
}
