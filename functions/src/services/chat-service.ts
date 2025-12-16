/**
 * Serwis obsługi czatu grupowego pasażerów
 */

import * as admin from "firebase-admin";
import {Chat, ChatMessage} from "../types";

export class ChatService {
  private db: admin.firestore.Firestore;

  constructor(db: admin.firestore.Firestore) {
    this.db = db;
  }

  /**
   * Tworzy lub pobiera czat dla danego połączenia
   */
  async getOrCreateChat(connectionInstanceId: string, trainNumber: string, departureTime: Date): Promise<Chat> {
    const chatRef = this.db.collection("chats").doc(connectionInstanceId);
    const chatDoc = await chatRef.get();

    if (chatDoc.exists) {
      return chatDoc.data() as Chat;
    }

    // Utwórz nowy czat
    const chat: Chat = {
      chatId: connectionInstanceId,
      connectionInstanceId: connectionInstanceId,
      trainNumber: trainNumber,
      departureTime: departureTime,
      participants: [],
      createdAt: new Date(),
      lastMessageAt: new Date(),
    };

    await chatRef.set({
      ...chat,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastMessageAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return chat;
  }

  /**
   * Dodaje użytkownika do czatu
   */
  async addParticipant(chatId: string, userId: string): Promise<void> {
    const chatRef = this.db.collection("chats").doc(chatId);
    await chatRef.update({
      participants: admin.firestore.FieldValue.arrayUnion(userId),
    });
  }

  /**
   * Wysyła wiadomość na czacie
   */
  async sendMessage(chatId: string, userId: string, userName: string, content: string): Promise<ChatMessage> {
    const messageId = this.db.collection("chats").doc().id;

    const message: ChatMessage = {
      messageId: messageId,
      chatId: chatId,
      userId: userId,
      userName: userName,
      content: content,
      timestamp: new Date(),
      type: "text",
    };

    // Zapisz wiadomość
    await this.db
      .collection("chats")
      .doc(chatId)
      .collection("messages")
      .doc(messageId)
      .set({
        ...message,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Zaktualizuj czas ostatniej wiadomości
    await this.db.collection("chats").doc(chatId).update({
      lastMessageAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return message;
  }

  /**
   * Pobiera wiadomości z czatu
   */
  async getMessages(chatId: string, limit: number = 50): Promise<ChatMessage[]> {
    const messagesSnapshot = await this.db
      .collection("chats")
      .doc(chatId)
      .collection("messages")
      .orderBy("timestamp", "desc")
      .limit(limit)
      .get();

    return messagesSnapshot.docs.map((doc) => doc.data() as ChatMessage);
  }

  /**
   * Wysyła systemową wiadomość powitalną
   */
  async sendWelcomeMessage(chatId: string, userName: string): Promise<void> {
    const messageId = this.db.collection("chats").doc().id;
    const content = `${userName} dołączył/a do czatu. Witamy! 👋`;

    await this.db
      .collection("chats")
      .doc(chatId)
      .collection("messages")
      .doc(messageId)
      .set({
        messageId: messageId,
        chatId: chatId,
        userId: "system",
        userName: "System",
        content: content,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        type: "system",
      });
  }
}
