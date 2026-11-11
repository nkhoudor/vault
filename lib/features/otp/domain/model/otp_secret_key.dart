/// Rules for the Base32 key a service shows when setting up two-factor authentication.
abstract final class OtpSecretKey {
  static final _separators = RegExp(r'[\s-]');
  static final _padding = RegExp(r'=+$');
  static final _base32 = RegExp(r'^[A-Z2-7]+$');

  /// Unpadded Base32 lengths, modulo 8, that decode to whole bytes.
  static const _validRemainders = {0, 2, 4, 5, 7};

  /// Upper-cases [input] and drops the spaces, dashes and padding that services add for readability.
  static String normalize(String input) => input.replaceAll(_separators, '').toUpperCase().replaceAll(_padding, '');

  /// Whether [input], once normalized, is a Base32 string that decodes to at least one byte.
  static bool isValid(String input) {
    final key = normalize(input);
    return _base32.hasMatch(key) && _validRemainders.contains(key.length % 8);
  }
}
