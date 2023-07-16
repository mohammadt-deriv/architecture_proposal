import 'package:architecture_proposal_data/src/mappers.dart';
import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class AuthRepository implements Authenticator {
  AuthRepository({required this.source, required this.storage});

  final DataSource source;
  final KeyValueStorage storage;

  static const String tokenStorageKey = 'token_key';

  @override
  Future<User> tokenLogin(String token) async {
    final request = <String, dynamic>{'authorize': token};

    try {
      final response = await source.request(request: request);
      final User user = response.toUser();

      storage.save(tokenStorageKey, token);

      return user;
    } catch (error) {
      throw toAuthError(error);
    }
  }

  @override
  Future<void> logout() async {
    final request = <String, dynamic>{'logout': 1};

    try {
      await source.request(request: request);
      storage.delete(tokenStorageKey);
    } catch (error) {
      throw toAuthError(error);
    }
  }

  @override
  Future<User> loginSavedUser() async {
    final token = await storage.load(tokenStorageKey);

    if (token == null) {
      throw AuthError(
        type: AuthErrorType.invalidToken,
        message: 'No saved token',
      );
    } else {
      return tokenLogin(token);
    }
  }
}

AuthError toAuthError(Object error) {
  if (error is DataException) {
    final code = error.code;
    final message = error.message;
    return AuthError(
      type: code == 'InvalidToken'
          ? AuthErrorType.invalidToken
          : AuthErrorType.undefined,
      message: message,
    );
  } else {
    return AuthError(
      type: AuthErrorType.undefined,
      message: error.toString(),
    );
  }
}
