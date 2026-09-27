import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<MessageEntity> create(MessageEntity message);
  Future<List<MessageEntity>> getByChatId(String chatId);
  Stream<List<MessageEntity>> watchByChatId(String chatId);
  Future<void> delete(String chatId, String messageId);
}
