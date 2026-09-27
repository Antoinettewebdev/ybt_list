import 'package:firebase_auth/firebase_auth.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';

/// Maps exceptions and Firebase errors to domain [Failure]s.
abstract final class ExceptionMapper {
  static Failure toFailure(Object error) {
    if (error is Failure) return error;
    if (error is AuthException) return AuthFailure(error.message);
    if (error is FirestoreException) return FirestoreFailure(error.message);
    if (error is NetworkException) return NetworkFailure(error.message);
    if (error is FirebaseAuthException) {
      return AuthFailure(_authMessage(error));
    }
    if (error is FirebaseException) {
      return FirestoreFailure(error.message ?? 'Firestore operation failed.');
    }
    return UnknownFailure(error.toString());
  }

  static String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
