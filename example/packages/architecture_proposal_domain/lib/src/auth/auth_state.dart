import 'package:architecture_proposal_domain/src/auth/auth_error.dart';
import 'package:architecture_proposal_domain/src/auth/user.dart';

abstract class AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoggedInState extends AuthState {
  AuthLoggedInState(this.user);

  final User user;
}

class AuthLoggedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  AuthErrorState(this.error);

  final AuthError error;
}
