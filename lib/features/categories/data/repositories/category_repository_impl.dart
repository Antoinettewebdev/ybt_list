import '../../../../core/data/base_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends BaseRepositoryImpl<CategoryEntity>
    implements CategoryRepository {
  CategoryRepositoryImpl(super.dataSource);
}
