import '../entities/payment_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class PaymentRepository extends CrudRepository<PaymentEntity> {}
