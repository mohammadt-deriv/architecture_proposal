import 'package:architecture_proposal_domain/src/tick/tick.dart';

abstract class TickStreamFetcher {
  // TOOD: remove subscriptionId from the return type
  Future<(Stream<Tick> ticks, String subscriptionId)> listenTickStream(
      String symbol);
  Future<void> forgotTickStream(String subscriptionId);
}
