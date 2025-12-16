/**
 * Provider wyszukiwania połączeń kolejowych
 * MVP: Mock implementation - w produkcji integracja z API PKP/PolRegio
 */

import {RailConnection, RailSearchQuery} from "../types";

export class RailSearchProvider {
  /**
   * Wyszukuje połączenia kolejowe
   * @param query Parametry wyszukiwania
   * @return Lista dostępnych połączeń
   */
  async searchConnections(query: RailSearchQuery): Promise<RailConnection[]> {
    // Mock data dla MVP
    const mockConnections: RailConnection[] = [
      {
        connectionId: "PKP-IC-5300",
        origin: query.origin,
        destination: query.destination,
        departureTime: new Date(query.date.getTime() + 10 * 60 * 60 * 1000), // 10:00
        arrivalTime: new Date(query.date.getTime() + 12.5 * 60 * 60 * 1000), // 12:30
        duration: 150,
        trainNumber: "IC 5300",
        carrier: "PKP Intercity",
        price: 89.0,
        availableSeats: 45,
      },
      {
        connectionId: "PKP-IC-5302",
        origin: query.origin,
        destination: query.destination,
        departureTime: new Date(query.date.getTime() + 14 * 60 * 60 * 1000), // 14:00
        arrivalTime: new Date(query.date.getTime() + 16.5 * 60 * 60 * 1000), // 16:30
        duration: 150,
        trainNumber: "IC 5302",
        carrier: "PKP Intercity",
        price: 89.0,
        availableSeats: 32,
      },
      {
        connectionId: "PKP-TLK-3500",
        origin: query.origin,
        destination: query.destination,
        departureTime: new Date(query.date.getTime() + 8 * 60 * 60 * 1000), // 08:00
        arrivalTime: new Date(query.date.getTime() + 11 * 60 * 60 * 1000), // 11:00
        duration: 180,
        trainNumber: "TLK 3500",
        carrier: "PKP Intercity",
        price: 65.0,
        availableSeats: 58,
      },
    ];

    // Zwróć pierwsze 3 wyniki
    return mockConnections.slice(0, 3);
  }

  /**
   * Pobiera szczegóły konkretnego połączenia
   */
  async getConnectionDetails(connectionId: string): Promise<RailConnection | null> {
    // Mock - w rzeczywistości zapytanie do API
    const mockConnection: RailConnection = {
      connectionId: connectionId,
      origin: "Warszawa Centralna",
      destination: "Kraków Główny",
      departureTime: new Date(),
      arrivalTime: new Date(Date.now() + 2.5 * 60 * 60 * 1000),
      duration: 150,
      trainNumber: connectionId.replace("PKP-", ""),
      carrier: "PKP Intercity",
      price: 89.0,
      availableSeats: 45,
    };

    return mockConnection;
  }
}
