import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter/material.dart';

import 'tick_stream_widget/tick_stream_widget.dart';

class MarketPriceViewer extends StatelessWidget {
  const MarketPriceViewer({
    required this.tickStreamFetcher,
    required this.selectedSymbolStream,
    super.key,
  });

  final Stream<ActiveSymbol> selectedSymbolStream;
  final TickStreamFetcher tickStreamFetcher;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: StreamBuilder<ActiveSymbol>(
          stream: selectedSymbolStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<ActiveSymbol> snapshot,
          ) {
            if (snapshot.hasData) {
              return TickStreamWidget(
                symbol: snapshot.data!,
                fetcher: tickStreamFetcher,
              );
            } else {
              return const Text('Please select an active symbol.');
            }
          },
        ),
      );
}
