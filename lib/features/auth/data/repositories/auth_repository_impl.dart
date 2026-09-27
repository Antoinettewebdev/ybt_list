import '../../../../core/utils/exception_mapper.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;

  @override
  UserEntity? get currentUser => _dataSource.currentFirebaseUser;

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      return await _dataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.signInWithEmail(
        email: email,
        password: password,
      );
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      return await _dataSource.signInWithGoogle();
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
    } catch (e) {
      throw ExceptionMapper.toFailure(e);
    }
  }
}
