import '../../../../core/data/base_repository_impl.dart';
import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl
    extends BaseRepositoryImpl<NotificationEntity>
    implements NotificationRepository {
  NotificationRepositoryImpl(this._dataSource) : super(_dataSource);

  final NotificationRemoteDataSource _dataSource;

  @override
  Stream<List<NotificationEntity>> watchByUser(String userId) =>
      _dataSource.watchByUser(userId).handleError(
            (Object e, StackTrace _) {
              throw ExceptionMapper.toFailure(e);
            },
          );
}
