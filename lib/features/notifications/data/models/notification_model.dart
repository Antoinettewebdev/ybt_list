import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    super.type,
    super.isRead,
    super.data,
    super.createdAt,
  });

  factory NotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final raw = doc.data() ?? {};
    return NotificationModel(
      id: doc.id,
      userId: raw['userId'] as String? ?? '',
      title: raw['title'] as String? ?? '',
      body: raw['body'] as String? ?? '',
      type: FirestoreSerialization.enumFromString(
        NotificationType.values,
        raw['type'] as String?,
        NotificationType.general,
      ),
      isRead: raw['isRead'] as bool? ?? false,
      data: Map<String, dynamic>.from(raw['data'] ?? {}),
      createdAt: FirestoreSerialization.parseDate(raw['createdAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) => {
        'userId': userId,
        'title': title,
        'body': body,
        'type': FirestoreSerialization.enumToString(type),
        'isRead': isRead,
        'data': data,
      };
}
