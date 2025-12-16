/**
 * Cloud Functions dla Ticket-by-Call/SMS + In-Train Chat MVP
 */

import * as admin from "firebase-admin";

// Inicjalizacja Firebase Admin
admin.initializeApp();

// Eksport webhooków
export {voiceMessageWebhook} from "./webhooks/voice-message-webhook";
export {smsWebhook} from "./webhooks/sms-webhook";

// TODO: Dodatkowe funkcje do dodania w przyszłości:
// - callWebhook dla połączeń głosowych w czasie rzeczywistym
// - scheduledCleanup dla czyszczenia starych sesji
// - onBookingCreated trigger dla wysyłania SMS potwierdzających
