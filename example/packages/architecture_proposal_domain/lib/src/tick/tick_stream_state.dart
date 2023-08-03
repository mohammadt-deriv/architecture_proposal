import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

abstract class TickStreamState {
  Tick? get getLatestTick =>
      asOrNull<TickStreamLoadedState>()?.ticks.lastOrNull;
  TickState? get getTickState => asOrNull<TickStreamLoadedState>()?.state;
  List<Tick> get getTicks => asOrNull<TickStreamLoadedState>()?.ticks ?? [];

  String get getTickSubscriptionId =>
      asOrNull<TickStreamLoadedState>()?.tickSubscriptionId ?? '';
}

class TickStreamInitialState extends TickStreamState {}

class TickStreamErrorState extends TickStreamState {
  TickStreamErrorState(this.error);

  final DataException error;
}

class TickStreamLoadingState extends TickStreamState {}

class TickStreamLoadedState extends TickStreamState {
  TickStreamLoadedState({
    required this.tickSubscriptionId,
    required this.ticks,
    required this.state,
  });

  final String tickSubscriptionId;
  final List<Tick> ticks;
  final TickState state;
}
