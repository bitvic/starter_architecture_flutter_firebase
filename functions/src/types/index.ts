/**
 * Typy danych dla systemu Ticket-by-Call/SMS + In-Train Chat
 */

// User types
export interface User {
  uid: string;
  phoneNumber: string;
  createdAt: Date;
  lastActive: Date;
}

// Conversation Session types
export interface ConversationSession {
  sessionId: string;
  userId: string;
  phoneNumber: string;
  channel: "whatsapp" | "messenger" | "sms" | "voice";
  status: "active" | "completed" | "expired";
  currentIntent: string | null;
  slots: Record<string, any>;
  messageHistory: Message[];
  createdAt: Date;
  updatedAt: Date;
}

export interface Message {
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
}

// Intent and NLU types
export interface Intent {
  name: string;
  confidence: number;
  slots: Record<string, any>;
}

export interface NLUResult {
  intent: Intent;
  entities: Entity[];
  rawText: string;
}

export interface Entity {
  type: string;
  value: string;
  confidence: number;
}

// Rail search types
export interface RailSearchQuery {
  origin: string;
  destination: string;
  date: Date;
  time?: string;
  passengers?: number;
}

export interface RailConnection {
  connectionId: string;
  origin: string;
  destination: string;
  departureTime: Date;
  arrivalTime: Date;
  duration: number; // minutes
  trainNumber: string;
  carrier: string;
  price: number;
  availableSeats: number;
}

// Booking types
export interface Booking {
  bookingId: string;
  userId: string;
  connectionId: string;
  connectionInstanceId: string; // dla czatu (np. "PKP-IC-5300-2025-12-16-10:00")
  status: "pending" | "confirmed" | "cancelled" | "completed";
  passengers: number;
  totalPrice: number;
  paymentStatus: "pending" | "paid" | "refunded";
  smsConfirmationSent: boolean;
  createdAt: Date;
  updatedAt: Date;
  connection: RailConnection;
}

// Chat types
export interface Chat {
  chatId: string; // równe connectionInstanceId
  connectionInstanceId: string;
  trainNumber: string;
  departureTime: Date;
  participants: string[]; // array of userIds
  createdAt: Date;
  lastMessageAt: Date;
}

export interface ChatMessage {
  messageId: string;
  chatId: string;
  userId: string;
  userName: string;
  content: string;
  timestamp: Date;
  type: "text" | "system";
}

// Telephony provider types
export interface TelephonyMessage {
  messageId: string;
  from: string;
  to: string;
  body?: string;
  mediaUrl?: string;
  mediaContentType?: string;
}

export interface TelephonyResponse {
  success: boolean;
  messageId?: string;
  error?: string;
}

// ASR/TTS types
export interface ASRConfig {
  languageCode: string;
  encoding: string;
  sampleRateHertz: number;
}

export interface TTSConfig {
  languageCode: string;
  voiceName: string;
  audioEncoding: string;
}

// Audit log types
export interface AuditLog {
  id: string;
  userId: string;
  action: string;
  details: Record<string, any>;
  timestamp: Date;
  ipAddress?: string;
}

// Webhook request types
export interface VoiceMessageWebhookRequest {
  MessageSid: string;
  From: string;
  To: string;
  MediaUrl0?: string;
  MediaContentType0?: string;
  NumMedia: string;
}

export interface SMSWebhookRequest {
  MessageSid: string;
  From: string;
  To: string;
  Body: string;
}
