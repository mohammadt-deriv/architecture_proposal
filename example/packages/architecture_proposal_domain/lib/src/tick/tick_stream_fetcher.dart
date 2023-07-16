import 'package:architecture_proposal_domain/src/tick/tick.dart';

abstract class TickStreamFetcher {
  Future<Stream<Tick>> listenTickStream(String symbol);
  Future<void> forgotTickStream(String subscriptionId);
}
