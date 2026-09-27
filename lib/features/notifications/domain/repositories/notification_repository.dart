import '../entities/notification_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class NotificationRepository extends CrudRepository<NotificationEntity> {
  Stream<List<NotificationEntity>> watchByUser(String userId);
}
