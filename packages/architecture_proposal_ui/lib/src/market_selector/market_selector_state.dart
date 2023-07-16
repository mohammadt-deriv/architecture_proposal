import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

abstract class MarketSelectorState {
  List<ActiveSymbol> get activeSymbols =>
      asOrNull<MarketSelectorLoadedState>()?.loadedSymbols ?? [];

  ActiveSymbol? get selectedSymbol =>
      asOrNull<MarketSelectorSelectedState>()?.selectedActiveSymbol;

  bool get isLoading => this is MarketSelectorLoadingState;
}

class MarketSelectorInitialState extends MarketSelectorState {}

class MarketSelectorLoadingState extends MarketSelectorState {}

class MarketSelectorErrorState extends MarketSelectorState {
  MarketSelectorErrorState(this.error);
  final DataException error;
}

class MarketSelectorLoadedState extends MarketSelectorState {
  MarketSelectorLoadedState({required this.loadedSymbols});

  final List<ActiveSymbol> loadedSymbols;
}

class MarketSelectorSelectedState extends MarketSelectorLoadedState {
  MarketSelectorSelectedState({
    required this.selectedActiveSymbol,
    required super.loadedSymbols,
  });

  final ActiveSymbol selectedActiveSymbol;
}
