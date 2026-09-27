/// Thrown by data sources when a remote/local operation fails.
class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class FirestoreException extends AppException {
  const FirestoreException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}
