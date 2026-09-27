import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/firestore_timestamp.dart';
import '../models/message_model.dart';

class MessageRemoteDataSource {
  MessageRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messages(String chatId) =>
      _firestore
          .collection(FirestorePaths.chats)
          .doc(chatId)
          .collection(FirestorePaths.messages);

  Future<MessageModel> create(MessageModel message) async {
    try {
      final data = FirestoreTimestamp.withServerTimestamps(
        isCreate: true,
        data: message.toMap(),
      );
      await _messages(message.chatId).doc(message.id).set(data);
      final doc = await _messages(message.chatId).doc(message.id).get();
      return MessageModel.fromFirestore(doc, chatId: message.chatId);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'Create message failed.', code: e.code);
    }
  }

  Future<List<MessageModel>> getByChatId(String chatId) async {
    try {
      final snapshot = await _messages(chatId)
          .orderBy('createdAt', descending: false)
          .get();
      return snapshot.docs
          .map((d) => MessageModel.fromFirestore(d, chatId: chatId))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'List messages failed.', code: e.code);
    }
  }

  Stream<List<MessageModel>> watchByChatId(String chatId) {
    return _messages(chatId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => MessageModel.fromFirestore(d, chatId: chatId))
              .toList(),
        );
  }

  Future<void> delete(String chatId, String messageId) async {
    try {
      await _messages(chatId).doc(messageId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'Delete message failed.', code: e.code);
    }
  }
}
