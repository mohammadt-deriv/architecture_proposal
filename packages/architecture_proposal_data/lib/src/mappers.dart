import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

extension JsonMapper on Map<String, dynamic> {
  List<ActiveSymbol> toActiveSymbols() {
    final List<dynamic> activeSymbols = this['active_symbols'];

    return activeSymbols
        .map((dynamic data) => ActiveSymbol(
              market: data['market'],
              marketDisplayName: data['market_display_name'],
              symbol: data['symbol'],
              symbolDisplayName: data['display_name'],
            ))
        .toList();
  }

  Tick toTick() {
    final Map<String, dynamic> tick = this['tick'];
    return Tick(
      epoch: tick['epoch'] ?? 0,
      quote: tick['quote'],
      symbol: tick['symbol'],
      pipSize: tick['pip_size'],
    );
  }
}
