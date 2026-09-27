import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.type = NotificationType.general,
    this.isRead = false,
    this.data = const {},
    this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic> data;
  final DateTime? createdAt;

  @override
  List<Object?> get props =>
      [id, userId, title, body, type, isRead, data, createdAt];
}

enum NotificationType {
  general,
  order,
  chat,
  payment,
  promotion,
}
