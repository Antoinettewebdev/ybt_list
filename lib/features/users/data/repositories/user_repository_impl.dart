import '../../../../core/data/base_repository_impl.dart';
import '../../../../core/utils/exception_mapper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl extends BaseRepositoryImpl<UserEntity>
    implements UserRepository {
  UserRepositoryImpl(this._dataSource) : super(_dataSource);

  final UserRemoteDataSource _dataSource;

  @override
  Future<UserEntity?> getByEmail(String email) async {
    try {
      return await _dataSource.getByEmail(email);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }

  @override
  Future<void> createIfNotExists(UserEntity user) async {
    try {
      await _dataSource.createIfNotExists(UserModel.fromEntity(user));
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }
}
