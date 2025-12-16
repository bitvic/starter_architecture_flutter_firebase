import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/chat/domain/chat.dart';
import 'package:starter_architecture_flutter_firebase/src/features/chat/domain/chat_message.dart';

part 'chat_repository.g.dart';

/// Repository obsługi czatu
class ChatRepository {
  const ChatRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// Stream czatu
  Stream<Chat?> watchChat(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return Chat.fromMap(doc.data()!, doc.id);
    });
  }

  /// Stream wiadomości czatu
  Stream<List<ChatMessage>> watchChatMessages(String chatId, {int limit = 50}) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Wysyła wiadomość
  Future<void> sendMessage({
    required String chatId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final message = ChatMessage(
      messageId: messageRef.id,
      chatId: chatId,
      userId: userId,
      userName: userName,
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    await messageRef.set(message.toMap());

    // Aktualizuj czas ostatniej wiadomości w czacie
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  /// Pobiera czaty użytkownika
  Stream<List<Chat>> watchUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chat.fromMap(doc.data(), doc.id))
            .toList());
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<Chat?> chat(ChatRef ref, String chatId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchChat(chatId);
}

@riverpod
Stream<List<ChatMessage>> chatMessages(ChatMessagesRef ref, String chatId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchChatMessages(chatId);
}

@riverpod
Stream<List<Chat>> userChats(UserChatsRef ref, String userId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchUserChats(userId);
}
