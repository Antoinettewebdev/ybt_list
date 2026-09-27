import '../../../../core/data/base_repository_impl.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl extends BaseRepositoryImpl<PaymentEntity>
    implements PaymentRepository {
  PaymentRepositoryImpl(super.dataSource);
}
