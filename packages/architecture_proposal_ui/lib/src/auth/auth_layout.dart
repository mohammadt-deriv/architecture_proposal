import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:architecture_proposal_ui/src/auth/auth_listener.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({
    required this.authStateManager,
    required this.onAuthSuccess,
    required this.onGuestLoginTapped,
    required this.onError,
    super.key,
  });

  final AuthManager authStateManager;
  final void Function(User user) onAuthSuccess;
  final void Function() onGuestLoginTapped;
  final void Function(String error) onError;

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  late final TextEditingController _tokenController;

  @override
  void initState() {
    _tokenController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => AuthListener(
        authManager: widget.authStateManager,
        onLoggedIn: widget.onAuthSuccess,
        onError: (error) => widget.onError(error.message),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Token',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton.icon(
                        onPressed: widget.authStateManager.currentState
                                is AuthLoadingState
                            ? null
                            : widget.onGuestLoginTapped,
                        icon: const Icon(Icons.person),
                        label: const Text('Guest Login'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<AuthState>(
                        stream: widget.authStateManager.authStateStream,
                        builder: (context, snapshot) => TextButton.icon(
                          onPressed: widget.authStateManager.currentState
                                  is AuthLoadingState
                              ? null
                              : _onLoginPressed,
                          icon: const Icon(Icons.login),
                          label: const Text('Login'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  void _onLoginPressed() =>
      widget.authStateManager.login(_tokenController.text);

  @override
  void dispose() {
    _tokenController.dispose();

    super.dispose();
  }
}
