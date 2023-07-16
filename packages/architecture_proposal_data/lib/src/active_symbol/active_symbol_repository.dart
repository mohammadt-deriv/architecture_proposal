import 'package:architecture_proposal_data/src/mappers.dart';
import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class ActiveSymbolRepository implements ActiveSymbolsFetcher {
  ActiveSymbolRepository({required this.source});

  final DataSource source;

  static const fetchAllSymbolsCacheKey = 'fetchAllSymbols';

  @override
  Future<List<ActiveSymbol>> fetchAllSymbols() async {
    final request = <String, dynamic>{
      'active_symbols': 'brief',
      'product_type': 'basic',
    };

    final response = await source.request(request: request);

    final symbols = response.toActiveSymbols();

    return symbols;
  }
}
