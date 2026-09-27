import '../../../users/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;

  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);
}
