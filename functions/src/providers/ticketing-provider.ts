/**
 * Provider obsługi rezerwacji i biletów
 * MVP: Mock implementation - w produkcji integracja z systemem biletowym
 */

import {Booking, RailConnection} from "../types";
import * as admin from "firebase-admin";

export class TicketingProvider {
  private db: admin.firestore.Firestore;

  constructor(db: admin.firestore.Firestore) {
    this.db = db;
  }

  /**
   * Tworzy rezerwację biletu
   */
  async createBooking(
    userId: string,
    connection: RailConnection,
    passengers: number
  ): Promise<Booking> {
    const bookingId = this.generateBookingId();
    const connectionInstanceId = this.generateConnectionInstanceId(connection);

    const booking: Booking = {
      bookingId: bookingId,
      userId: userId,
      connectionId: connection.connectionId,
      connectionInstanceId: connectionInstanceId,
      status: "pending",
      passengers: passengers,
      totalPrice: connection.price * passengers,
      paymentStatus: "pending",
      smsConfirmationSent: false,
      createdAt: new Date(),
      updatedAt: new Date(),
      connection: connection,
    };

    // Zapisz w Firestore
    await this.db.collection("bookings").doc(bookingId).set({
      ...booking,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return booking;
  }

  /**
   * Potwierdza rezerwację (symulacja płatności dla MVP)
   */
  async confirmBooking(bookingId: string): Promise<boolean> {
    try {
      await this.db.collection("bookings").doc(bookingId).update({
        status: "confirmed",
        paymentStatus: "paid",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return true;
    } catch (error) {
      console.error("Błąd potwierdzania rezerwacji:", error);
      return false;
    }
  }

  /**
   * Anuluje rezerwację
   */
  async cancelBooking(bookingId: string): Promise<boolean> {
    try {
      await this.db.collection("bookings").doc(bookingId).update({
        status: "cancelled",
        paymentStatus: "refunded",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return true;
    } catch (error) {
      console.error("Błąd anulowania rezerwacji:", error);
      return false;
    }
  }

  /**
   * Generuje unikalny ID rezerwacji
   */
  private generateBookingId(): string {
    const timestamp = Date.now().toString(36);
    const random = Math.random().toString(36).substring(2, 9);
    return `BK-${timestamp}-${random}`.toUpperCase();
  }

  /**
   * Generuje ID instancji połączenia dla czatu
   * Format: {trainNumber}-{YYYY-MM-DD}-{HH:mm}
   */
  private generateConnectionInstanceId(connection: RailConnection): string {
    const date = connection.departureTime;
    const dateStr = date.toISOString().split("T")[0];
    const timeStr = date.toTimeString().substring(0, 5);
    return `${connection.trainNumber.replace(/\s+/g, "-")}-${dateStr}-${timeStr}`;
  }
}
