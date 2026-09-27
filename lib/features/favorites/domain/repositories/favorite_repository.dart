import '../entities/favorite_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class FavoriteRepository extends CrudRepository<FavoriteEntity> {
  Future<List<FavoriteEntity>> getByUser(String userId);
}
