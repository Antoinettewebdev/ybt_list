import '../entities/chat_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class ChatRepository extends CrudRepository<ChatEntity> {
  Stream<List<ChatEntity>> watchUserChats(String userId);
}
