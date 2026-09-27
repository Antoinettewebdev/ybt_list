import '../../../../core/data/base_repository_impl.dart';
import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl extends BaseRepositoryImpl<ProductEntity>
    implements ProductRepository {
  ProductRepositoryImpl(this._dataSource) : super(_dataSource);

  final ProductRemoteDataSource _dataSource;

  @override
  Future<List<ProductEntity>> getByCategory(String categoryId) async {
    try {
      return await _dataSource.getByCategory(categoryId);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }
}
