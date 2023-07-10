import 'package:architecture_proposal_data/src/mappers.dart';
import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class TickStreamRepository implements TickStreamFetcher {
  TickStreamRepository({required this.source});

  final DataSource source;

  @override
  Future<(Stream<Tick>, String)> listenTickStream(String symbol) async {
    final request = <String, dynamic>{
      'ticks': symbol,
      'subscribe': 1,
    };

    final (stream, subscriptionId) =
        await source.requestStream(request: request);

    return (stream.map((event) => event.toTick()), subscriptionId);
  }

  @override
  Future<void> forgotTickStream(String subscriptionId) async {
    final request = {'forget': subscriptionId};

    if (subscriptionId.isNotEmpty) {
      await source.request(request: request);
    }
  }
}
