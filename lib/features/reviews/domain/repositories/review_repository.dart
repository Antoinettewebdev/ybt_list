import '../entities/review_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class ReviewRepository extends CrudRepository<ReviewEntity> {
  Future<List<ReviewEntity>> getByProduct(String productId);
}
