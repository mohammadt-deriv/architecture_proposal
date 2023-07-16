import 'dart:async';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter/material.dart';

class AuthListener extends StatefulWidget {
  const AuthListener({
    required this.authManager,
    this.onLoggedIn,
    this.onError,
    this.onLoggedOut,
    required this.child,
    super.key,
  });
  final AuthManager authManager;
  final void Function(User user)? onLoggedIn;
  final void Function()? onLoggedOut;
  final void Function(AuthError error)? onError;
  final Widget child;

  @override
  State<AuthListener> createState() => _AuthListenerState();
}

class _AuthListenerState extends State<AuthListener> {
  late final StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = widget.authManager.authStateStream.listen((state) {
      if (state is AuthLoggedInState) {
        widget.onLoggedIn?.call(state.user);
      }
      if (state is AuthErrorState) {
        widget.onError?.call(state.error);
      }
      if (state is AuthLoggedOutState) {
        widget.onLoggedOut?.call();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }
}
