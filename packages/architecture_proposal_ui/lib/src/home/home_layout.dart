import 'dart:async';

import 'package:architecture_proposal_ui/src/market_selector/market_selector.dart';
import 'package:flutter/material.dart';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:architecture_proposal_ui/src/market_price/market_price_viewer.dart';

/// Layouts are equivalent to old pages that we used to have in the past.
/// They are responsible for the layout of a screen and they are part of `UI` layer(package).
///
/// Layouts should be as testable as possible,
/// so they provide all dependencies of their children widgets, as parameters in their constructors.
///
/// As `MarketSelector` and `SymbolPriceViewer` are 2 independent widgets,
/// we used `StreamController` to bind 2 children widgets together with `Stream<ActiveSymbol>.
class HomeLayout extends StatefulWidget {
  const HomeLayout({
    required this.activeSymbolsFetcher,
    required this.tickStreamFetcher,
    super.key,
  });

  final ActiveSymbolsFetcher activeSymbolsFetcher;
  final TickStreamFetcher tickStreamFetcher;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late final StreamController<ActiveSymbol> selectedActiveSymbolController;

  @override
  void initState() {
    selectedActiveSymbolController = StreamController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('App Architecture Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 48,
                child: MarketSelector(
                  activeSymbolsFetcher: widget.activeSymbolsFetcher,
                  onActiveSymbolChanged: selectedActiveSymbolController.add,
                ),
              ),
              Expanded(
                child: MarketPriceViewer(
                  selectedSymbolStream: selectedActiveSymbolController.stream,
                  tickStreamFetcher: widget.tickStreamFetcher,
                ),
              ),
            ],
          ),
        ),
      );
}
