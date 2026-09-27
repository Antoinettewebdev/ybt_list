import '../entities/order_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class OrderRepository extends CrudRepository<OrderEntity> {
  Stream<List<OrderEntity>> watchByUser(String userId);
}
