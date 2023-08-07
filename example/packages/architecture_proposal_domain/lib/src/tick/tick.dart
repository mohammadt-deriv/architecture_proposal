import 'package:architecture_proposal_domain/src/tick/tick_state.dart';

class Tick {
  Tick({
    required this.id,
    required this.epoch,
    required this.quote,
    required this.symbol,
    required this.pipSize,
  });

  final String id;
  final int epoch;
  final num quote;
  final String symbol;
  final int pipSize;

  TickState getPriceState({required Tick? previous}) {
    if (previous == null) {
      return TickState.none;
    }

    return quote == previous.quote
        ? TickState.none
        : quote > previous.quote
            ? TickState.up
            : TickState.down;
  }
}
