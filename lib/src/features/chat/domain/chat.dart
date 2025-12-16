import 'package:equatable/equatable.dart';

/// Model czatu grupowego dla pasażerów
class Chat extends Equatable {
  const Chat({
    required this.chatId,
    required this.connectionInstanceId,
    required this.trainNumber,
    required this.departureTime,
    required this.participants,
    required this.createdAt,
    required this.lastMessageAt,
  });

  final String chatId;
  final String connectionInstanceId;
  final String trainNumber;
  final DateTime departureTime;
  final List<String> participants; // lista userIds
  final DateTime createdAt;
  final DateTime lastMessageAt;

  factory Chat.fromMap(Map<String, dynamic> map, String id) {
    return Chat(
      chatId: id,
      connectionInstanceId: map['connectionInstanceId'] as String,
      trainNumber: map['trainNumber'] as String,
      departureTime: (map['departureTime'] as dynamic).toDate(),
      participants: List<String>.from(map['participants'] as List),
      createdAt: (map['createdAt'] as dynamic).toDate(),
      lastMessageAt: (map['lastMessageAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'connectionInstanceId': connectionInstanceId,
      'trainNumber': trainNumber,
      'departureTime': departureTime,
      'participants': participants,
      'createdAt': createdAt,
      'lastMessageAt': lastMessageAt,
    };
  }

  @override
  List<Object?> get props => [
        chatId,
        connectionInstanceId,
        trainNumber,
        departureTime,
        participants,
        createdAt,
        lastMessageAt,
      ];
}
