import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'market_selector_state.dart';

/// This Cubit is dedicated to a ui.
/// so all public methods should represent an action in that ui.
/// and all private methods should represent a business logic.
///
/// Its a best practice to start all public methods with `on` prefix.
class MarketSelectorCubit extends Cubit<MarketSelectorState> {
  MarketSelectorCubit({required this.fetcher})
      : super(MarketSelectorInitialState());

  final ActiveSymbolsFetcher fetcher;

  /// Instead of having `loadSymbols` method, we should have `onWidgetInit` method,
  /// and calling private `_loadSymbols` method inside it,
  /// Because this cubit is specifically for `ActiveSymbolSelector` widget.
  void onInit() async => _loadSymbols();

  /// Instead of having `selectSymbol` method, we should have `onSymbolSelected` method,
  void onSymbolSelected(ActiveSymbol? symbol) {
    if (symbol == null) {
      return;
    }

    emit(
      MarketSelectorSelectedState(
        selectedActiveSymbol: symbol,
        loadedSymbols: state.activeSymbols,
      ),
    );
  }

  void _loadSymbols() => fetcher.fetchAllSymbols().on(
        onLoading: () => emit(MarketSelectorLoadingState()),
        onData: (data) => emit(MarketSelectorLoadedState(loadedSymbols: data)),
        onError: (DataException error) => emit(MarketSelectorErrorState(error)),
      );
}
