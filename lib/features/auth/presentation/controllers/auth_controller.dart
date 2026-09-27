import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/state/resource.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, Resource<UserEntity?>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<Resource<UserEntity?>> {
  AuthController(this._authRepository) : super(const ResourceInitial());

  final AuthRepository _authRepository;

  void setUser(UserEntity? user) {
    state = ResourceSuccess(user);
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const ResourceLoading();
    try {
      final user = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = ResourceSuccess(user);
    } on Failure catch (f) {
      state = ResourceError(f);
    } catch (e) {
      state = ResourceError(UnknownFailure(e.toString()));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const ResourceLoading();
    try {
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      state = ResourceSuccess(user);
    } on Failure catch (f) {
      state = ResourceError(f);
    } catch (e) {
      state = ResourceError(UnknownFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    state = const ResourceLoading();
    try {
      final user = await _authRepository.signInWithGoogle();
      state = ResourceSuccess(user);
    } on Failure catch (f) {
      state = ResourceError(f);
    } catch (e) {
      state = ResourceError(UnknownFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    state = const ResourceLoading();
    try {
      await _authRepository.signOut();
      state = const ResourceSuccess(null);
    } on Failure catch (f) {
      state = ResourceError(f);
    } catch (e) {
      state = ResourceError(UnknownFailure(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    state = const ResourceLoading();
    try {
      await _authRepository.sendPasswordResetEmail(email);
      state = ResourceSuccess(_authRepository.currentUser);
    } on Failure catch (f) {
      state = ResourceError(f);
    } catch (e) {
      state = ResourceError(UnknownFailure(e.toString()));
    }
  }
}
