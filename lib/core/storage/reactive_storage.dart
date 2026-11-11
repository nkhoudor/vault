/// Abstract contract for reactive string key-value storage.
/// Implementations can use SharedPreferences, RxSharedPreferences, etc.
abstract interface class ReactiveStorage {
  /// Stream of value changes for [key]. Emits current value and subsequent updates.
  Stream<String?> getStringStream(String key);

  /// Returns the current value for [key], or null if not set.
  Future<String?> getString(String key);

  /// Persists [value] for [key].
  Future<void> setString(String key, String value);
}
