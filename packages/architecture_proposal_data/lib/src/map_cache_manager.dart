import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class MapCacheManager implements CacheManager {
  final cache = <String, Object>{};

  @override
  T? load<T extends Object>(String key) =>
      cache.containsKey(key) ? cache[key].asOrNull<T>() : null;

  @override
  void save<T extends Object>(String key, T value) => cache[key] = value;
}
