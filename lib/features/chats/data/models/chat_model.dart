import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.participantIds,
    super.title,
    super.lastMessage,
    super.lastMessageAt,
    super.type,
    super.createdAt,
    super.updatedAt,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ChatModel(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      title: data['title'] as String?,
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: FirestoreSerialization.parseDate(data['lastMessageAt']),
      type: FirestoreSerialization.enumFromString(
        ChatType.values,
        data['type'] as String?,
        ChatType.direct,
      ),
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
      updatedAt: FirestoreSerialization.parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    final map = <String, dynamic>{
      'participantIds': participantIds,
      'title': title,
      'lastMessage': lastMessage,
      'type': FirestoreSerialization.enumToString(type),
    };
    if (lastMessageAt != null) {
      map['lastMessageAt'] = Timestamp.fromDate(lastMessageAt!);
    }
    if (!isCreate && createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
}
