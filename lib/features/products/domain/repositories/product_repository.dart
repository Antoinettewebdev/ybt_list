import '../entities/product_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class ProductRepository extends CrudRepository<ProductEntity> {
  Future<List<ProductEntity>> getByCategory(String categoryId);
}
