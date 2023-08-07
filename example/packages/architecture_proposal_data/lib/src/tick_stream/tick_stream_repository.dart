import 'package:architecture_proposal_data/src/mappers.dart';
import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class TickStreamRepository implements TickStreamFetcher {
  TickStreamRepository({required this.source});

  final DataSource source;

  @override
  Future<Stream<Tick>> listenTickStream(String symbol) async {
    final request = <String, dynamic>{
      'ticks': symbol,
      'subscribe': 1,
    };

    final stream = await source.requestStream(request: request);

    return stream.map((event) => event.toTick());
  }

  @override
  Future<void> forgetTickStream(String subscriptionId) async {
    if (subscriptionId.isNotEmpty) {
      final request = {'forget': subscriptionId};

      await source.request(request: request);
    }
  }
}
