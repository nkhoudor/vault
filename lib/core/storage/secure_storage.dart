/// Abstract contract for secure string key-value storage.
/// Implementations use platform secure storage (e.g. Keychain, Keystore).
abstract interface class SecureStorage {
  /// Returns the current value for [key], or null if not set.
  Future<String?> getString(String key);

  /// Persists [value] for [key].
  Future<void> setString(String key, String value);

  /// Stream of value changes for [key]. Emits current value and subsequent updates.
  Stream<String?> getStringStream(String key);
}
