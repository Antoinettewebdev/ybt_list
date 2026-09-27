import '../../../../core/data/base_repository_impl.dart';
import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl extends BaseRepositoryImpl<OrderEntity>
    implements OrderRepository {
  OrderRepositoryImpl(this._dataSource) : super(_dataSource);

  final OrderRemoteDataSource _dataSource;

  @override
  Stream<List<OrderEntity>> watchByUser(String userId) =>
      _dataSource.watchByUser(userId).handleError(
            (Object e, StackTrace _) {
              throw ExceptionMapper.toFailure(e);
            },
          );
}
