import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/async_value_widget.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/empty_content.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/bookings/data/bookings_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/bookings/domain/booking.dart';

/// Ekran listy moich podróży (rezerwacji)
class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Zaloguj się, aby zobaczyć swoje podróże')),
      );
    }

    final bookingsAsync = ref.watch(activeBookingsProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje Podróże'),
      ),
      body: AsyncValueWidget(
        value: bookingsAsync,
        data: (bookings) {
          if (bookings.isEmpty) {
            return const EmptyContent(
              title: 'Brak zaplanowanych podróży',
              message: 'Twoje rezerwacje pojawią się tutaj',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return BookingCard(
                booking: booking,
                onTap: () {
                  // Przejdź do czatu dla tego połączenia
                  context.go('/chat/${booking.connectionInstanceId}');
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Karta pojedynczej rezerwacji
class BookingCard extends StatelessWidget {
  const BookingCard({
    required this.booking,
    required this.onTap,
    super.key,
  });

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final connection = booking.connection;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nagłówek z numerem pociągu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    connection.trainNumber,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  _StatusChip(status: booking.status),
                ],
              ),
              const SizedBox(height: 12),
              // Trasa
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          connection.origin,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          timeFormat.format(connection.departureTime),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward, size: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          connection.destination,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          timeFormat.format(connection.arrivalTime),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Data i cena
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat.format(connection.departureTime),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${booking.totalPrice.toStringAsFixed(2)} PLN',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Przycisk do czatu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.chat),
                  label: const Text('Otwórz czat pasażerów'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip ze statusem rezerwacji
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case BookingStatus.confirmed:
        color = Colors.green;
        label = 'Potwierdzona';
        break;
      case BookingStatus.pending:
        color = Colors.orange;
        label = 'Oczekuje';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        label = 'Anulowana';
        break;
      case BookingStatus.completed:
        color = Colors.grey;
        label = 'Zakończona';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
