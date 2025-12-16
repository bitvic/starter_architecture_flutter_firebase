/**
 * Orchestrator - Główna logika zarządzania konwersacją
 * Obsługuje intencje, sloty i przepływ rozmowy
 */

import * as admin from "firebase-admin";
import {ConversationSession, Intent, NLUResult, RailSearchQuery} from "../types";
import {RailSearchProvider} from "../providers/rail-search-provider";
import {TicketingProvider} from "../providers/ticketing-provider";
import {ChatService} from "./chat-service";

export class ConversationOrchestrator {
  private db: admin.firestore.Firestore;
  private railSearchProvider: RailSearchProvider;
  private ticketingProvider: TicketingProvider;
  private chatService: ChatService;

  constructor(db: admin.firestore.Firestore) {
    this.db = db;
    this.railSearchProvider = new RailSearchProvider();
    this.ticketingProvider = new TicketingProvider(db);
    this.chatService = new ChatService(db);
  }

  /**
   * Przetwarza wiadomość użytkownika i generuje odpowiedź
   */
  async processMessage(sessionId: string, userMessage: string): Promise<string> {
    // Pobierz lub utwórz sesję
    let session = await this.getOrCreateSession(sessionId);

    // Dodaj wiadomość do historii
    session.messageHistory.push({
      role: "user",
      content: userMessage,
      timestamp: new Date(),
    });

    // Analiza NLU (uproszczona dla MVP)
    const nluResult = await this.analyzeIntent(userMessage, session);

    // Przetwórz intencję i zaktualizuj sloty
    const response = await this.handleIntent(session, nluResult);

    // Dodaj odpowiedź do historii
    session.messageHistory.push({
      role: "assistant",
      content: response,
      timestamp: new Date(),
    });

    // Zapisz sesję
    await this.saveSession(session);

    return response;
  }

  /**
   * Prosta analiza intencji (NLU) - dla MVP używamy regexów
   * W produkcji: DialogFlow / LUIS / własny model NLU
   */
  private async analyzeIntent(message: string, session: ConversationSession): Promise<NLUResult> {
    const lowerMessage = message.toLowerCase();

    // Intencja: Wyszukiwanie połączenia
    if (lowerMessage.includes("szukam") ||
        lowerMessage.includes("chcę jechać") ||
        lowerMessage.includes("połączenie") ||
        lowerMessage.includes("pociąg")) {
      return {
        intent: {name: "search_connection", confidence: 0.9, slots: {}},
        entities: this.extractEntities(message),
        rawText: message,
      };
    }

    // Intencja: Potwierdzenie
    if (lowerMessage.includes("tak") ||
        lowerMessage.includes("potwierdzam") ||
        lowerMessage.includes("ok") ||
        lowerMessage.includes("dobrze")) {
      return {
        intent: {name: "confirm", confidence: 0.95, slots: {}},
        entities: [],
        rawText: message,
      };
    }

    // Intencja: Anulowanie
    if (lowerMessage.includes("nie") ||
        lowerMessage.includes("anuluj") ||
        lowerMessage.includes("rezygnuję")) {
      return {
        intent: {name: "cancel", confidence: 0.95, slots: {}},
        entities: [],
        rawText: message,
      };
    }

    // Domyślnie: Provide info
    return {
      intent: {name: "provide_info", confidence: 0.5, slots: {}},
      entities: this.extractEntities(message),
      rawText: message,
    };
  }

  /**
   * Ekstrakcja encji z tekstu (uproszczona)
   * TODO: W produkcji użyć DialogFlow/LUIS lub własnego modelu NLU
   */
  private extractEntities(message: string): any[] {
    const entities: any[] = [];

    // Miasta polskie - TODO: przenieść do konfiguracji/bazy danych
    // W produkcji: integracja z API miast PKP lub baza danych
    const cities = ["warszawa", "kraków", "wrocław", "poznań", "gdańsk", "katowice", "łódź"];
    cities.forEach((city) => {
      if (message.toLowerCase().includes(city)) {
        entities.push({type: "city", value: city, confidence: 0.9});
      }
    });

    // Data (dzisiaj, jutro)
    if (message.toLowerCase().includes("dzisiaj") || message.toLowerCase().includes("dziś")) {
      entities.push({type: "date", value: "today", confidence: 0.95});
    }
    if (message.toLowerCase().includes("jutro")) {
      entities.push({type: "date", value: "tomorrow", confidence: 0.95});
    }

    return entities;
  }

  /**
   * Obsługa intencji i generowanie odpowiedzi
   */
  private async handleIntent(session: ConversationSession, nluResult: NLUResult): Promise<string> {
    const intent = nluResult.intent.name;

    switch (intent) {
    case "search_connection":
      return await this.handleSearchConnection(session, nluResult);
    case "confirm":
      return await this.handleConfirm(session);
    case "cancel":
      return await this.handleCancel(session);
    case "provide_info":
      return await this.handleProvideInfo(session, nluResult);
    default:
      return "Przepraszam, nie zrozumiałem. Możesz spróbować ponownie?";
    }
  }

  /**
   * Obsługa wyszukiwania połączenia
   */
  private async handleSearchConnection(
    session: ConversationSession,
    nluResult: NLUResult
  ): Promise<string> {
    // Aktualizuj sloty na podstawie encji
    nluResult.entities.forEach((entity) => {
      if (entity.type === "city") {
        if (!session.slots.origin) {
          session.slots.origin = entity.value;
        } else if (!session.slots.destination) {
          session.slots.destination = entity.value;
        }
      }
      if (entity.type === "date") {
        session.slots.date = entity.value;
      }
    });

    // Sprawdź czy mamy wszystkie wymagane sloty
    if (!session.slots.origin) {
      session.currentIntent = "search_connection";
      return "Z jakiego miasta chcesz wyjechać?";
    }
    if (!session.slots.destination) {
      session.currentIntent = "search_connection";
      return `Dokąd chcesz jechać z ${session.slots.origin}?`;
    }
    if (!session.slots.date) {
      session.currentIntent = "search_connection";
      return "Na kiedy szukasz połączenia? (dzisiaj/jutro)";
    }

    // Mamy wszystkie dane - wyszukaj połączenia
    const query: RailSearchQuery = {
      origin: this.capitalizeCityName(session.slots.origin),
      destination: this.capitalizeCityName(session.slots.destination),
      date: this.parseDateSlot(session.slots.date),
      passengers: 1,
    };

    const connections = await this.railSearchProvider.searchConnections(query);

    if (connections.length === 0) {
      return "Nie znaleziono połączeń. Spróbuj innej daty lub tras.";
    }

    // Zapisz połączenia w sesji
    session.slots.connections = connections;
    session.currentIntent = "select_connection";

    // Formatuj odpowiedź
    let response = `Znalazłem ${connections.length} połączenia:\n\n`;
    connections.forEach((conn, index) => {
      const depTime = this.formatTime(conn.departureTime);
      const arrTime = this.formatTime(conn.arrivalTime);
      response += `${index + 1}. ${conn.trainNumber} - Odjazd: ${depTime}, Przyjazd: ${arrTime}, `;
      response += `Cena: ${conn.price.toFixed(2)} PLN\n`;
    });

    response += "\nWybierz numer połączenia (np. '1') lub napisz 'anuluj'.";

    return response;
  }

  /**
   * Obsługa potwierdzenia
   */
  private async handleConfirm(session: ConversationSession): Promise<string> {
    if (session.currentIntent === "confirm_booking" && session.slots.selectedConnection) {
      // Utwórz rezerwację
      const connection = session.slots.selectedConnection;
      const userId = session.userId;

      try {
        const booking = await this.ticketingProvider.createBooking(userId, connection, 1);

        // Automatycznie potwierdź (w MVP bez płatności)
        await this.ticketingProvider.confirmBooking(booking.bookingId);

        // Dodaj użytkownika do czatu
        const chat = await this.chatService.getOrCreateChat(
          booking.connectionInstanceId,
          connection.trainNumber,
          connection.departureTime
        );
        await this.chatService.addParticipant(chat.chatId, userId);

        // Wyczyść sesję
        session.status = "completed";
        session.currentIntent = null;

        return `✅ Rezerwacja potwierdzona!\n\n` +
               `Numer rezerwacji: ${booking.bookingId}\n` +
               `Połączenie: ${connection.trainNumber}\n` +
               `Trasa: ${connection.origin} → ${connection.destination}\n` +
               `Odjazd: ${this.formatDateTime(connection.departureTime)}\n` +
               `Cena: ${booking.totalPrice.toFixed(2)} PLN\n\n` +
               `Zaloguj się w aplikacji aby dołączyć do czatu pasażerów tego pociągu!`;
      } catch (error) {
        console.error("Błąd tworzenia rezerwacji:", error);
        return "Przepraszam, wystąpił błąd podczas tworzenia rezerwacji. Spróbuj ponownie później.";
      }
    }

    return "Co chciałbyś potwierdzić?";
  }

  /**
   * Obsługa anulowania
   */
  private async handleCancel(session: ConversationSession): Promise<string> {
    session.status = "completed";
    session.currentIntent = null;
    session.slots = {};
    return "Anulowano. Jeśli chcesz wyszukać połączenie, wyślij nową wiadomość.";
  }

  /**
   * Obsługa dostarczania informacji (liczby, wybór)
   */
  private async handleProvideInfo(session: ConversationSession, nluResult: NLUResult): Promise<string> {
    const message = nluResult.rawText;

    // Jeśli oczekujemy wyboru połączenia
    if (session.currentIntent === "select_connection" && session.slots.connections) {
      const choice = parseInt(message.trim());
      const connections = session.slots.connections;

      if (choice >= 1 && choice <= connections.length) {
        const selectedConnection = connections[choice - 1];
        session.slots.selectedConnection = selectedConnection;
        session.currentIntent = "confirm_booking";

        return `Wybrałeś:\n` +
               `${selectedConnection.trainNumber}\n` +
               `${selectedConnection.origin} → ${selectedConnection.destination}\n` +
               `Odjazd: ${this.formatDateTime(selectedConnection.departureTime)}\n` +
               `Cena: ${selectedConnection.price.toFixed(2)} PLN\n\n` +
               `Czy potwierdzasz rezerwację? (tak/nie)`;
      } else {
        return "Nieprawidłowy numer. Wybierz liczbę z listy lub napisz 'anuluj'.";
      }
    }

    // Aktualizuj sloty na podstawie encji
    nluResult.entities.forEach((entity) => {
      if (entity.type === "city") {
        if (!session.slots.origin) {
          session.slots.origin = entity.value;
        } else if (!session.slots.destination) {
          session.slots.destination = entity.value;
        }
      }
    });

    // Kontynuuj zbieranie slotów
    if (session.currentIntent === "search_connection") {
      return await this.handleSearchConnection(session, nluResult);
    }

    return "Jak mogę Ci pomóc? Możesz wyszukać połączenie kolejowe mówiąc np. " +
           "'Chcę jechać z Warszawy do Krakowa jutro'.";
  }

  /**
   * Pobiera lub tworzy sesję konwersacji
   */
  private async getOrCreateSession(sessionId: string): Promise<ConversationSession> {
    const sessionRef = this.db.collection("conversationSessions").doc(sessionId);
    const sessionDoc = await sessionRef.get();

    if (sessionDoc.exists) {
      const data = sessionDoc.data();
      return {
        ...data,
        createdAt: data!.createdAt?.toDate() || new Date(),
        updatedAt: data!.updatedAt?.toDate() || new Date(),
      } as ConversationSession;
    }

    // Utwórz nową sesję
    // MVP: używamy sessionId jako userId - TO JEST TYMCZASOWE ROZWIĄZANIE
    // TODO KRYTYCZNE: W produkcji należy:
    //  1. Zaimplementować proper user management z Firebase Auth
    //  2. Powiązać numer telefonu z userId poprzez Custom Claims lub Firestore
    //  3. Utworzyć osobną kolekcję phoneNumbers -> userId mapping
    //  4. Dodać weryfikację Phone Auth podczas pierwszego logowania
    const newSession: ConversationSession = {
      sessionId: sessionId,
      userId: sessionId, // TEMPORARY - replace with proper userId
      phoneNumber: "unknown",
      channel: "sms",
      status: "active",
      currentIntent: null,
      slots: {},
      messageHistory: [],
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return newSession;
  }

  /**
   * Zapisuje sesję w Firestore
   */
  private async saveSession(session: ConversationSession): Promise<void> {
    await this.db.collection("conversationSessions").doc(session.sessionId).set({
      ...session,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});
  }

  /**
   * Pomocnicze funkcje formatowania
   */
  private capitalizeCityName(city: string): string {
    return city.charAt(0).toUpperCase() + city.slice(1);
  }

  private parseDateSlot(dateSlot: string): Date {
    const now = new Date();
    if (dateSlot === "today") {
      return now;
    }
    if (dateSlot === "tomorrow") {
      const tomorrow = new Date(now);
      tomorrow.setDate(tomorrow.getDate() + 1);
      return tomorrow;
    }
    return now;
  }

  private formatTime(date: Date): string {
    return date.toLocaleTimeString("pl-PL", {hour: "2-digit", minute: "2-digit"});
  }

  private formatDateTime(date: Date): string {
    return date.toLocaleString("pl-PL", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    });
  }
}
