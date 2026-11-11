import 'package:app_core/core/storage/reactive_storage.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

/// [ReactiveStorage] implementation backed by [RxSharedPreferences].
class RxSharedPreferencesStorage implements ReactiveStorage {
  RxSharedPreferencesStorage();

  late final RxSharedPreferences _prefs = RxSharedPreferences.getInstance();

  @override
  Stream<String?> getStringStream(String key) => _prefs.getStringStream(key);

  @override
  Future<String?> getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  Future<void> dispose() => _prefs.dispose();
}
