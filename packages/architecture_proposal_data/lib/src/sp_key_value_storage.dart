import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPKeyValueStorage implements KeyValueStorage {
  final sp = SharedPreferences.getInstance();

  @override
  Future<String?> load(String key) async {
    final storage = await sp;
    return storage.containsKey(key) ? storage.getString(key) : null;
  }

  @override
  Future<void> save(String key, String value) async {
    final storage = await sp;

    await storage.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    final storage = await sp;

    await storage.remove(key);
  }
}
