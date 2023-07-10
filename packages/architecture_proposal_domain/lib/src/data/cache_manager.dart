abstract class CacheManager {
  void save<T extends Object>(String key, T value);
  T? load<T extends Object>(String key);
}
