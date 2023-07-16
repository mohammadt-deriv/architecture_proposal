import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

abstract class TickStreamWidgetState {
  Tick? get getTick => asOrNull<TickStreamLoadedState>()?.loadedTick;
  TickState? get getTickState => asOrNull<TickStreamLoadedState>()?.state;

  String get getTickSubscriptionId =>
      asOrNull<TickStreamLoadedState>()?.tickSubscriptionId ?? '';
}

class TickStreamWidgetInitialState extends TickStreamWidgetState {}

class TickStreamWidgetErrorState extends TickStreamWidgetState {
  TickStreamWidgetErrorState(this.error);

  final DataException error;
}

class TickStreamWidgetLoadingState extends TickStreamWidgetState {}

class TickStreamLoadedState extends TickStreamWidgetState {
  TickStreamLoadedState({
    required this.tickSubscriptionId,
    required this.loadedTick,
    required this.state,
  });

  final String tickSubscriptionId;
  final Tick loadedTick;
  final TickState state;
}
