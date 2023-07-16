import 'dart:async';

import 'package:architecture_proposal_ui/src/auth/auth_listener.dart';
import 'package:architecture_proposal_ui/src/market_selector/market_selector.dart';
import 'package:architecture_proposal_ui/src/test_feature/feature_a.dart';
import 'package:architecture_proposal_ui/src/test_feature/feature_b.dart';
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
    required this.authManager,
    required this.onLoggedOut,
    required this.onError,
    this.featureAEnabled = false,
    this.featureBEnabled = false,
    super.key,
  });

  final ActiveSymbolsFetcher activeSymbolsFetcher;
  final TickStreamFetcher tickStreamFetcher;
  final AuthManager authManager;
  final bool featureAEnabled;
  final bool featureBEnabled;
  final void Function() onLoggedOut;
  final void Function(String error) onError;

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

  String get loggedInUsername =>
      widget.authManager.currentUser?.email ?? 'Guest';

  @override
  Widget build(BuildContext context) => AuthListener(
        authManager: widget.authManager,
        onLoggedOut: widget.onLoggedOut,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('Home'),
            actions: [
              TextButton.icon(
                onPressed: widget.authManager.logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Logged in as: $loggedInUsername'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: MarketSelector(
                    activeSymbolsFetcher: widget.activeSymbolsFetcher,
                    onActiveSymbolChanged: selectedActiveSymbolController.add,
                    onError: (error) => widget.onError(error.message),
                  ),
                ),
                MarketPriceViewer(
                  selectedSymbolStream: selectedActiveSymbolController.stream,
                  tickStreamFetcher: widget.tickStreamFetcher,
                  onError: (error) => widget.onError(error.message),
                ),
                Expanded(
                    child: Column(
                  children: [
                    if (widget.featureAEnabled) const FeatureA(),
                    if (widget.featureBEnabled) const FeatureB(),
                  ],
                ))
              ],
            ),
          ),
        ),
      );
}
