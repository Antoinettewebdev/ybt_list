import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/exceptions.dart' show AuthException, FirestoreException;
import '../../../users/data/datasources/user_remote_data_source.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/domain/entities/user_entity.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required UserRemoteDataSource userRemoteDataSource,
  })  : _auth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _userDataSource = userRemoteDataSource;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final UserRemoteDataSource _userDataSource;

  Stream<UserEntity?> get authStateChanges =>
      _auth.authStateChanges().asyncMap(_mapFirebaseUser);

  UserEntity? get currentFirebaseUser =>
      _auth.currentUser != null
          ? _minimalUser(_auth.currentUser!)
          : null;

  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user!;
      if (displayName != null && displayName.isNotEmpty) {
        await firebaseUser.updateDisplayName(displayName);
      }
      return _persistUser(
        firebaseUser: firebaseUser,
        email: email,
        displayName: displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign up failed.', code: e.code);
    }
  }

  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _resolveUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign in failed.', code: e.code);
    }
  }

  Future<UserEntity> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Sign-in was cancelled.', code: 'cancelled');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;
      return _persistUser(
        firebaseUser: firebaseUser,
        email: firebaseUser.email ?? googleUser.email,
        displayName: firebaseUser.displayName ?? googleUser.displayName,
        photoUrl: firebaseUser.photoURL ?? googleUser.photoUrl,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google sign in failed.', code: e.code);
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Reset email failed.', code: e.code);
    }
  }

  Future<UserEntity?> _mapFirebaseUser(User? firebaseUser) async {
    if (firebaseUser == null) return null;
    return _resolveUser(firebaseUser);
  }

  Future<UserEntity> _resolveUser(User firebaseUser) async {
    try {
      return await _userDataSource.getById(firebaseUser.uid);
    } on FirestoreException {
      return _persistUser(
        firebaseUser: firebaseUser,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
      );
    }
  }

  Future<UserEntity> _persistUser({
    required User firebaseUser,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    final user = UserModel(
      id: firebaseUser.uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
    );
    await _userDataSource.createIfNotExists(user);
    try {
      return await _userDataSource.getById(firebaseUser.uid);
    } catch (_) {
      return user;
    }
  }

  UserEntity _minimalUser(User firebaseUser) => UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
      );
}
