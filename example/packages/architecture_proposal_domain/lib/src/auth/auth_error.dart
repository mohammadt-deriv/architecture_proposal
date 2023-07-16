enum AuthErrorType {
  invalidToken,
  undefined,
}

class AuthError implements Exception {
  AuthError({required this.type, required this.message});

  final AuthErrorType type;
  final String message;
}
