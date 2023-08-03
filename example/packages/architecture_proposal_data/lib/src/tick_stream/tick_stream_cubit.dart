// ignore_for_file: invalid_return_type_for_catch_error

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class TickStreamCubit extends Cubit<TickStreamState>
    implements TickStreamManager {
  TickStreamCubit({required this.fetcher}) : super(TickStreamInitialState());

  final TickStreamFetcher fetcher;

  @override
  void loadTickStream(ActiveSymbol symbol) {
    fetcher.forgotTickStream(state.getTickSubscriptionId).on(
          onLoading: () => emit(TickStreamLoadingState()),
          onError: (DataException error) => emit(TickStreamErrorState(error)),
        );

    fetcher.listenTickStream(symbol.symbol).on(
          onLoading: () => emit(TickStreamLoadingState()),
          onData: (data) => data.listen(
            // TODO: add listen cancelation
            (tick) => emit(
              TickStreamLoadedState(
                ticks: [...state.getTicks, tick],
                tickSubscriptionId: tick.id,
                state:
                    getTickState(previous: state.getLatestTick, current: tick),
              ),
            ),
          ),
          onError: (DataException error) => emit(TickStreamErrorState(error)),
        );
  }

  @override
  Stream<List<Tick>> get tickStream =>
      stream.whereType<TickStreamLoadedState>().map((event) => event.ticks);

  @override
  Stream<TickStreamState> get stateSteam => stream;

  @override
  TickStreamState get currentState => state;
}
