import '../../../../core/data/base_repository_impl.dart';
import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl extends BaseRepositoryImpl<ChatEntity>
    implements ChatRepository {
  ChatRepositoryImpl(this._dataSource) : super(_dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Stream<List<ChatEntity>> watchUserChats(String userId) {
    try {
      return _dataSource.watchUserChats(userId);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }
}
