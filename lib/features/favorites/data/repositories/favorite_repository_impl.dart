import '../../../../core/data/base_repository_impl.dart';
import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_data_source.dart';

class FavoriteRepositoryImpl extends BaseRepositoryImpl<FavoriteEntity>
    implements FavoriteRepository {
  FavoriteRepositoryImpl(this._dataSource) : super(_dataSource);

  final FavoriteRemoteDataSource _dataSource;

  @override
  Future<List<FavoriteEntity>> getByUser(String userId) async {
    try {
      return await _dataSource.getByUser(userId);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }
}
