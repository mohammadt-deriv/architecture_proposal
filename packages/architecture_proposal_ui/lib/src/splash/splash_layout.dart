import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:architecture_proposal_ui/src/auth/auth_listener.dart';
import 'package:flutter/material.dart';

class SplashLayout extends StatefulWidget {
  const SplashLayout({
    required this.authManager,
    required this.onUserExist,
    required this.onNewUser,
    super.key,
  });

  final AuthManager authManager;
  final void Function(User user) onUserExist;
  final void Function() onNewUser;

  @override
  State<SplashLayout> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends State<SplashLayout> {
  @override
  void initState() {
    widget.authManager.loginSavedUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => AuthListener(
        authManager: widget.authManager,
        onLoggedIn: widget.onUserExist,
        onLoggedOut: widget.onNewUser,
        onError: (error) {
          if (error.type == AuthErrorType.invalidToken) {
            widget.onNewUser();
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
