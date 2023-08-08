import 'dart:async';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter/material.dart';

class AppOverlay extends StatefulWidget {
  const AppOverlay({
    required this.child,
    required this.appConnectionProvider,
    super.key,
  });

  final Widget child;

  final AppConnectionProvider appConnectionProvider;

  @override
  State<AppOverlay> createState() => _AppOverlayState();
}

class _AppOverlayState extends State<AppOverlay> {
  late final StreamSubscription<bool> _subscription;

  @override
  void initState() {
    _subscription =
        widget.appConnectionProvider.isConnectedStream.listen((isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isOnline
                ? 'App is online now'
                : 'App is offline now. reconnecting ...',
          ),
        ),
      );
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
