// ignore_for_file: invalid_return_type_for_catch_error

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tick_stream_widget_state.dart';

class TickStreamWidgetCubit extends Cubit<TickStreamWidgetState> {
  TickStreamWidgetCubit({required this.fetcher})
      : super(TickStreamWidgetInitialState());

  final TickStreamFetcher fetcher;

  void loadTickStream(ActiveSymbol symbol) {
    fetcher.forgotTickStream(state.getTickSubscriptionId).on(
          onLoading: () => emit(TickStreamWidgetLoadingState()),
          onError: (DataException error) =>
              emit(TickStreamWidgetErrorState(error)),
        );

    fetcher.listenTickStream(symbol.symbol).on(
          onLoading: () => emit(TickStreamWidgetLoadingState()),
          onData: (data) => data.listen(
            (tick) => emit(
              TickStreamLoadedState(
                loadedTick: tick,
                tickSubscriptionId: tick.id,
                state: getTickState(previous: state.getTick, current: tick),
              ),
            ),
          ),
          onError: (DataException error) =>
              emit(TickStreamWidgetErrorState(error)),
        );
  }
}
