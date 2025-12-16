import 'package:equatable/equatable.dart';

/// Typ wiadomości
enum MessageType { text, system }

/// Model wiadomości czatu
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.messageId,
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  final String messageId;
  final String chatId;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;
  final MessageType type;

  factory ChatMessage.fromMap(Map<String, dynamic> map, String id) {
    return ChatMessage(
      messageId: id,
      chatId: map['chatId'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      content: map['content'] as String,
      timestamp: (map['timestamp'] as dynamic).toDate(),
      type: _typeFromString(map['type'] as String? ?? 'text'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': timestamp,
      'type': type.name,
    };
  }

  static MessageType _typeFromString(String type) {
    return MessageType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => MessageType.text,
    );
  }

  bool get isSystemMessage => type == MessageType.system;

  @override
  List<Object?> get props => [
        messageId,
        chatId,
        userId,
        userName,
        content,
        timestamp,
        type,
      ];
}
