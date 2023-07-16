import 'package:architecture_proposal_domain/src/auth/auth_state.dart';
import 'package:architecture_proposal_domain/src/auth/user.dart';

abstract class AuthManager {
  void login(String token);
  void logout();
  void loginSavedUser();

  Stream<AuthState> get authStateStream;

  AuthState get currentState;

  User? get currentUser;
}
