import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

abstract class ActiveSymbolsFetcher {
  Future<List<ActiveSymbol>> fetchAllSymbols();
}
