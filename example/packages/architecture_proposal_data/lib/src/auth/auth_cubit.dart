import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<AuthState> implements AuthManager {
  AuthCubit({required this.authenticator}) : super(AuthLoggedOutState());

  final Authenticator authenticator;

  @override
  void login(String token) => authenticator.tokenLogin(token).on(
        onData: (user) => emit(AuthLoggedInState(user)),
        onError: (AuthError error) => emit(AuthErrorState(error)),
        onLoading: () => emit(AuthLoadingState()),
      );

  @override
  void loginSavedUser() => authenticator.loginSavedUser().on(
        onData: (user) => emit(AuthLoggedInState(user)),
        onError: (AuthError error) => emit(AuthErrorState(error)),
        onLoading: () => emit(AuthLoadingState()),
      );

  @override
  void logout() {
    if (currentUser == null) {
      emit(AuthLoggedOutState());
      return;
    }

    authenticator.logout().on(
          onData: (_) => emit(AuthLoggedOutState()),
          onError: (AuthError error) => emit(AuthErrorState(error)),
          onLoading: () => emit(AuthLoadingState()),
        );
  }

  @override
  Stream<AuthState> get authStateStream => stream;

  @override
  AuthState get currentState => state;

  @override
  User? get currentUser => currentState.asOrNull<AuthLoggedInState>()?.user;
}
