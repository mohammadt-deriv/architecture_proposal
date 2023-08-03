import 'package:architecture_proposal/helpers.dart';
import 'package:architecture_proposal/router.dart';
import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:architecture_proposal_ui/architecture_proposal_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) => AuthLayout(
        authStateManager: context.read<AuthManager>(),
        onAuthSuccess: (user) => context.goHome(),
        onGuestLoginTapped: () => context.goHome(),
        onError: (error) => showError(context, error),
      );
}
