import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/bookings/domain/booking.dart';

part 'bookings_repository.g.dart';

/// Repository obsługi rezerwacji
class BookingsRepository {
  const BookingsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// Stream wszystkich rezerwacji użytkownika
  Stream<List<Booking>> watchUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Pobiera pojedynczą rezerwację
  Future<Booking?> fetchBooking(String bookingId) async {
    final doc = await _firestore.collection('bookings').doc(bookingId).get();
    if (!doc.exists) return null;
    return Booking.fromMap(doc.data()!, doc.id);
  }

  /// Pobiera rezerwacje użytkownika o określonym statusie
  Stream<List<Booking>> watchBookingsByStatus(
    String userId,
    BookingStatus status,
  ) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Pobiera aktywne rezerwacje (confirmed, gdzie odjazd jest w przyszłości)
  Stream<List<Booking>> watchActiveBookings(String userId) {
    final now = DateTime.now();
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'confirmed')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .where((booking) => booking.connection.departureTime.isAfter(now))
            .toList());
  }
}

@riverpod
BookingsRepository bookingsRepository(BookingsRepositoryRef ref) {
  return BookingsRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Booking>> userBookings(UserBookingsRef ref, String userId) {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.watchUserBookings(userId);
}

@riverpod
Stream<List<Booking>> activeBookings(ActiveBookingsRef ref, String userId) {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.watchActiveBookings(userId);
}
