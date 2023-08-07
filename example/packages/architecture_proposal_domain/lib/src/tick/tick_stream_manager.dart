import 'package:architecture_proposal_domain/src/active_symbol/active_symbol.dart';
import 'package:architecture_proposal_domain/src/tick/tick.dart';
import 'package:architecture_proposal_domain/src/tick/tick_stream_state.dart';

abstract class TickStreamManager {
  void loadTickStream(ActiveSymbol symbol);
  void cancelTickStreams();

  Stream<List<Tick>> get tickStream;
  Stream<TickStreamState> get stateSteam;
  TickStreamState get currentState;
}
