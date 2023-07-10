import 'package:architecture_proposal_data/src/mappers.dart';
import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class ActiveSymbolRepository implements ActiveSymbolsFetcher {
  ActiveSymbolRepository({required this.source, required this.cacheManager});

  final DataSource source;

  // Optional
  final CacheManager cacheManager;

  static const fetchAllSymbolsCacheKey = 'fetchAllSymbols';

  @override
  Future<List<ActiveSymbol>> fetchAllSymbols() async {
    final result =
        cacheManager.load<List<ActiveSymbol>>(fetchAllSymbolsCacheKey);

    if (result != null) {
      return result;
    }

    final request = <String, dynamic>{
      'active_symbols': 'brief',
      'product_type': 'basic',
    };

    final response = await source.request(request: request);

    final symbols = response.toActiveSymbols();

    cacheManager.save(fetchAllSymbolsCacheKey, symbols);

    return response.toActiveSymbols();
  }
}
