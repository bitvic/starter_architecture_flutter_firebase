import 'package:equatable/equatable.dart';
import 'package:starter_architecture_flutter_firebase/src/features/bookings/domain/rail_connection.dart';

/// Status rezerwacji
enum BookingStatus { pending, confirmed, cancelled, completed }

/// Status płatności
enum PaymentStatus { pending, paid, refunded }

/// Model rezerwacji biletu
class Booking extends Equatable {
  const Booking({
    required this.bookingId,
    required this.userId,
    required this.connectionId,
    required this.connectionInstanceId,
    required this.status,
    required this.passengers,
    required this.totalPrice,
    required this.paymentStatus,
    required this.smsConfirmationSent,
    required this.createdAt,
    required this.updatedAt,
    required this.connection,
  });

  final String bookingId;
  final String userId;
  final String connectionId;
  final String connectionInstanceId; // dla czatu
  final BookingStatus status;
  final int passengers;
  final double totalPrice;
  final PaymentStatus paymentStatus;
  final bool smsConfirmationSent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RailConnection connection;

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      bookingId: id,
      userId: map['userId'] as String,
      connectionId: map['connectionId'] as String,
      connectionInstanceId: map['connectionInstanceId'] as String,
      status: _statusFromString(map['status'] as String),
      passengers: map['passengers'] as int,
      totalPrice: (map['totalPrice'] as num).toDouble(),
      paymentStatus: _paymentStatusFromString(map['paymentStatus'] as String),
      smsConfirmationSent: map['smsConfirmationSent'] as bool? ?? false,
      createdAt: (map['createdAt'] as dynamic).toDate(),
      updatedAt: (map['updatedAt'] as dynamic).toDate(),
      connection: RailConnection.fromMap(map['connection'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'connectionId': connectionId,
      'connectionInstanceId': connectionInstanceId,
      'status': status.name,
      'passengers': passengers,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus.name,
      'smsConfirmationSent': smsConfirmationSent,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'connection': connection.toMap(),
    };
  }

  static BookingStatus _statusFromString(String status) {
    return BookingStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => BookingStatus.pending,
    );
  }

  static PaymentStatus _paymentStatusFromString(String status) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => PaymentStatus.pending,
    );
  }

  @override
  List<Object?> get props => [
        bookingId,
        userId,
        connectionId,
        connectionInstanceId,
        status,
        passengers,
        totalPrice,
        paymentStatus,
        smsConfirmationSent,
        createdAt,
        updatedAt,
        connection,
      ];
}
