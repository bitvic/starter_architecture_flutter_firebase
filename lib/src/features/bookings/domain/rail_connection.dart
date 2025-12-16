import 'package:equatable/equatable.dart';

/// Model danych połączenia kolejowego
class RailConnection extends Equatable {
  const RailConnection({
    required this.connectionId,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.trainNumber,
    required this.carrier,
    required this.price,
    required this.availableSeats,
  });

  final String connectionId;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int duration; // w minutach
  final String trainNumber;
  final String carrier;
  final double price;
  final int availableSeats;

  factory RailConnection.fromMap(Map<String, dynamic> map) {
    return RailConnection(
      connectionId: map['connectionId'] as String,
      origin: map['origin'] as String,
      destination: map['destination'] as String,
      departureTime: (map['departureTime'] as dynamic).toDate(),
      arrivalTime: (map['arrivalTime'] as dynamic).toDate(),
      duration: map['duration'] as int,
      trainNumber: map['trainNumber'] as String,
      carrier: map['carrier'] as String,
      price: (map['price'] as num).toDouble(),
      availableSeats: map['availableSeats'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'connectionId': connectionId,
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'trainNumber': trainNumber,
      'carrier': carrier,
      'price': price,
      'availableSeats': availableSeats,
    };
  }

  @override
  List<Object?> get props => [
        connectionId,
        origin,
        destination,
        departureTime,
        arrivalTime,
        duration,
        trainNumber,
        carrier,
        price,
        availableSeats,
      ];
}
