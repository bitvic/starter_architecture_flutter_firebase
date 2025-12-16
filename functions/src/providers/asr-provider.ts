/**
 * Provider dla Google Cloud Speech-to-Text (ASR)
 */

import {SpeechClient} from "@google-cloud/speech";

export class ASRProvider {
  private client: SpeechClient;

  constructor() {
    this.client = new SpeechClient();
  }

  /**
   * Transkrybuje audio na tekst
   * @param audioBuffer Buffer z danymi audio
   * @param mimeType Typ MIME audio (np. "audio/ogg")
   * @return Transkrypcja tekstu
   */
  async transcribe(audioBuffer: Buffer, mimeType: string): Promise<string> {
    const audioBytes = audioBuffer.toString("base64");

    // Mapowanie MIME na encoding Google Cloud Speech
    const encodingMap: Record<string, any> = {
      "audio/ogg": "OGG_OPUS",
      "audio/mpeg": "MP3",
      "audio/wav": "LINEAR16",
      "audio/webm": "WEBM_OPUS",
    };

    const encoding = encodingMap[mimeType] || "LINEAR16";

    const request = {
      audio: {
        content: audioBytes,
      },
      config: {
        encoding: encoding,
        sampleRateHertz: 16000,
        languageCode: "pl-PL",
        enableAutomaticPunctuation: true,
      },
    };

    try {
      const [response] = await this.client.recognize(request);
      const transcription = response.results
        ?.map((result) => result.alternatives?.[0]?.transcript)
        .filter(Boolean)
        .join("\n") || "";

      return transcription;
    } catch (error) {
      console.error("Błąd transkrypcji ASR:", error);
      throw new Error("Nie udało się przetworzyć nagrania audio.");
    }
  }
}
