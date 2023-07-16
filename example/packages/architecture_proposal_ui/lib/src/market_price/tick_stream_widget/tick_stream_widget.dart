import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

import 'tick_stream_widget_cubit.dart';
import 'tick_stream_widget_state.dart';

class TickStreamWidget extends StatefulWidget {
  const TickStreamWidget({
    required this.fetcher,
    required this.symbol,
    required this.onError,
    super.key,
  });

  final ActiveSymbol symbol;
  final TickStreamFetcher fetcher;
  final void Function(DataException error) onError;

  @override
  State<TickStreamWidget> createState() => _TickStreamWidgetState();
}

class _TickStreamWidgetState extends State<TickStreamWidget> {
  late final TickStreamWidgetCubit _cubit;

  @override
  void didUpdateWidget(covariant TickStreamWidget oldWidget) {
    if (oldWidget.symbol != widget.symbol) {
      _cubit.loadTickStream(widget.symbol);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _cubit = TickStreamWidgetCubit(fetcher: widget.fetcher)
      ..loadTickStream(widget.symbol);

    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<TickStreamWidgetCubit, TickStreamWidgetState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is TickStreamWidgetErrorState) {
            widget.onError(state.error);
          }
        },
        builder: (context, state) => Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text(
                  'Symbol: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.symbol.symbolDisplayName),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                const Text(
                  'Quote: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      state.getTick?.quote
                              .toStringAsFixed(state.getTick?.pipSize ?? 0) ??
                          '-',
                      style: TextStyle(color: _getColor(state.getTickState)),
                    ),
                    _getIcon(state.getTickState)
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                const Text(
                  'Epoch: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(state.getTick?.epoch.getFormattedDateTime ?? '-'),
              ],
            ),
          ],
        ),
      );

  Widget _getIcon(TickState? state) => Icon(
        switch (state) {
          TickState.none => Icons.commit_rounded,
          TickState.up => Icons.arrow_drop_up_rounded,
          TickState.down => Icons.arrow_drop_down_rounded,
          null => Icons.commit_rounded
        },
        color: _getColor(state),
      );

  Color _getColor(TickState? state) => switch (state) {
        TickState.none => Colors.grey,
        TickState.up => Colors.green,
        TickState.down => Colors.red,
        null => Colors.grey,
      };
}
