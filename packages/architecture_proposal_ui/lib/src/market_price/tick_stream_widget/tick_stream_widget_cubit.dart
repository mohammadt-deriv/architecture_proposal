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
          onError: (error) => emit(TickStreamWidgetErrorState(error)),
        );

    fetcher.listenTickStream(symbol.symbol).on(
          onLoading: () => emit(TickStreamWidgetLoadingState()),
          onData: (data) => data.$1.listen(
            (tick) => emit(
              TickStreamLoadedState(
                loadedTick: tick,
                tickSubscriptionId: data.$2,
                state: getTickState(previous: state.getTick, current: tick),
              ),
            ),
          ),
          onError: (error) => emit(TickStreamWidgetErrorState(error)),
        );
  }
}
