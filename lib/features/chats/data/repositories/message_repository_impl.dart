import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_data_source.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this._dataSource);

  final MessageRemoteDataSource _dataSource;

  @override
  Future<MessageEntity> create(MessageEntity message) async {
    try {
      final model = MessageModel(
        id: message.id,
        chatId: message.chatId,
        senderId: message.senderId,
        text: message.text,
        type: message.type,
        attachments: message.attachments,
        readBy: message.readBy,
      );
      return await _dataSource.create(model);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }

  @override
  Future<List<MessageEntity>> getByChatId(String chatId) async {
    try {
      return await _dataSource.getByChatId(chatId);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }

  @override
  Stream<List<MessageEntity>> watchByChatId(String chatId) =>
      _dataSource.watchByChatId(chatId).handleError(
            (Object e, StackTrace _) {
              throw ExceptionMapper.toFailure(e);
            },
          );

  @override
  Future<void> delete(String chatId, String messageId) async {
    try {
      await _dataSource.delete(chatId, messageId);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }
}
