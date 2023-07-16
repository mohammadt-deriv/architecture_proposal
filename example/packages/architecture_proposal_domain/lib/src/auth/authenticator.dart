import 'package:architecture_proposal_domain/src/auth/user.dart';

abstract class Authenticator {
  Future<User> tokenLogin(String token);
  Future<User> loginSavedUser();
  Future<void> logout();
}
