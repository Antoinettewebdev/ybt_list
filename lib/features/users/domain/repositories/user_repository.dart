import '../entities/user_entity.dart';
import '../../../../core/domain/crud_repository.dart';

abstract class UserRepository extends CrudRepository<UserEntity> {
  Future<UserEntity?> getByEmail(String email);
  Future<void> createIfNotExists(UserEntity user);
}
