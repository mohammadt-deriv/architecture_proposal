import 'package:architecture_proposal_domain/src/tick/tick.dart';
import 'package:architecture_proposal_domain/src/tick/tick_state.dart';

TickState getTickState({Tick? previous, required Tick? current}) {
  if (previous == null || current == null) {
    return TickState.none;
  }

  return current.quote == previous.quote
      ? TickState.none
      : current.quote > previous.quote
          ? TickState.up
          : TickState.down;
}
