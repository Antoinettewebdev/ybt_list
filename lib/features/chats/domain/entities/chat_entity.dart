import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  const ChatEntity({
    required this.id,
    required this.participantIds,
    this.title,
    this.lastMessage,
    this.lastMessageAt,
    this.type = ChatType.direct,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final List<String> participantIds;
  final String? title;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final ChatType type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        participantIds,
        title,
        lastMessage,
        lastMessageAt,
        type,
        createdAt,
        updatedAt,
      ];
}

enum ChatType { direct, group }
