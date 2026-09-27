import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.text,
    super.type,
    super.attachments,
    super.readBy,
    super.createdAt,
  });

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    required String chatId,
  }) {
    final data = doc.data() ?? {};
    return MessageModel(
      id: doc.id,
      chatId: chatId,
      senderId: data['senderId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      type: FirestoreSerialization.enumFromString(
        MessageType.values,
        data['type'] as String?,
        MessageType.text,
      ),
      attachments: List<String>.from(data['attachments'] ?? []),
      readBy: List<String>.from(data['readBy'] ?? []),
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'text': text,
        'type': FirestoreSerialization.enumToString(type),
        'attachments': attachments,
        'readBy': readBy,
      };
}
