/// Why a scanned or pasted text could not be turned into an OTP secret.
enum OtpAuthUriError {
  /// Not an `otpauth://` link at all.
  notOtpAuth,

  /// An `otpauth://` link of a kind other than time-based (for example counter-based HOTP).
  unsupportedType,

  /// The key is missing or is not valid Base32.
  invalidSecret,

  /// Neither an issuer nor an account name, so the entry could not be told apart in the list.
  missingName,

  /// Digits, period or algorithm outside what the app can generate codes for.
  unsupportedParameters,
}

class OtpAuthUriException implements Exception {
  const OtpAuthUriException(this.error);

  final OtpAuthUriError error;

  @override
  String toString() => 'OtpAuthUriException(${error.name})';
}
