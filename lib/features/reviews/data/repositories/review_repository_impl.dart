import '../../../../core/data/base_repository_impl.dart';
import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl extends BaseRepositoryImpl<ReviewEntity>
    implements ReviewRepository {
  ReviewRepositoryImpl(this._dataSource) : super(_dataSource);

  final ReviewRemoteDataSource _dataSource;

  @override
  Future<List<ReviewEntity>> getByProduct(String productId) async {
    try {
      return await _dataSource.getByProduct(productId);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }
}
