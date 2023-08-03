import 'package:architecture_proposal_ui/src/market_price/tick_stream_widget/tick_stream_builder.dart';
import 'package:flutter/material.dart';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class TickStreamWidget extends StatefulWidget {
  const TickStreamWidget({
    required this.tickStreamManager,
    required this.symbol,
    required this.onError,
    super.key,
  });

  final ActiveSymbol symbol;
  final TickStreamManager tickStreamManager;
  final void Function(DataException error) onError;

  @override
  State<TickStreamWidget> createState() => _TickStreamWidgetState();
}

class _TickStreamWidgetState extends State<TickStreamWidget> {
  @override
  void didUpdateWidget(covariant TickStreamWidget oldWidget) {
    if (oldWidget.symbol != widget.symbol) {
      widget.tickStreamManager.loadTickStream(widget.symbol);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    widget.tickStreamManager.loadTickStream(widget.symbol);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => TickStreamBuilder(
        manager: widget.tickStreamManager,
        onError: widget.onError,
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
                      state.getLatestTick?.quote.toStringAsFixed(
                              state.getLatestTick?.pipSize ?? 0) ??
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
                Text(state.getLatestTick?.epoch.getFormattedDateTime ?? '-'),
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
