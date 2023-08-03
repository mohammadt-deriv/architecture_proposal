import 'dart:async';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter/material.dart';

class TickStreamBuilder extends StatefulWidget {
  const TickStreamBuilder({
    required this.manager,
    required this.builder,
    this.onError,
    super.key,
  });

  final TickStreamManager manager;
  final void Function(DataException error)? onError;
  final Widget Function(BuildContext context, TickStreamState state) builder;

  @override
  State<TickStreamBuilder> createState() => _TickStreamBuilderState();
}

class _TickStreamBuilderState extends State<TickStreamBuilder> {
  late final StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = widget.manager.stateSteam.listen((state) {
      if (state is TickStreamErrorState) {
        widget.onError?.call(state.error);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: widget.manager.stateSteam,
        builder: (context, snapshot) =>
            widget.builder(context, widget.manager.currentState),
      );

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }
}
