import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    this.type = MessageType.text,
    this.attachments = const [],
    this.readBy = const [],
    this.createdAt,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final MessageType type;
  final List<String> attachments;
  final List<String> readBy;
  final DateTime? createdAt;

  @override
  List<Object?> get props =>
      [id, chatId, senderId, text, type, attachments, readBy, createdAt];
}

enum MessageType { text, image, file, system }
