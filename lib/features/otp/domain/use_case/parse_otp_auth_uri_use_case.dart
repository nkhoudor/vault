import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_auth_uri_exception.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/model/otp_secret_key.dart';
import 'package:uuid/uuid.dart';

/// Turns the `otpauth://totp/...` link encoded in a setup QR code into an [OtpSecret].
///
/// Follows the Key URI format used by authenticator apps:
/// `otpauth://totp/Issuer:account?secret=KEY&issuer=Issuer&algorithm=SHA1&digits=6&period=30`.
class ParseOtpAuthUriUseCase {
  const ParseOtpAuthUriUseCase();

  static const _scheme = 'otpauth';
  static const _totpType = 'totp';
  static const _supportedDigits = {6, 7, 8};

  /// Throws an [OtpAuthUriException] when [text] is not a usable TOTP link.
  OtpSecret call(String text) {
    final uri = Uri.tryParse(text.trim());
    if (uri == null || uri.scheme.toLowerCase() != _scheme) {
      throw const OtpAuthUriException(OtpAuthUriError.notOtpAuth);
    }
    if (uri.host.toLowerCase() != _totpType) {
      throw const OtpAuthUriException(OtpAuthUriError.unsupportedType);
    }

    final Map<String, String> query;
    final String label;
    try {
      query = uri.queryParameters;
      label = uri.pathSegments.join('/');
    } on FormatException {
      // Uri decodes lazily and throws here for percent-encoded bytes that are not valid UTF-8.
      throw const OtpAuthUriException(OtpAuthUriError.notOtpAuth);
    }

    final secret = query['secret'] ?? '';
    if (!OtpSecretKey.isValid(secret)) {
      throw const OtpAuthUriException(OtpAuthUriError.invalidSecret);
    }

    final (labelIssuer, account) = _splitLabel(label);
    final issuerParameter = (query['issuer'] ?? '').trim();
    final issuer = issuerParameter.isNotEmpty ? issuerParameter : labelIssuer;
    if (issuer.isEmpty && account.isEmpty) {
      throw const OtpAuthUriException(OtpAuthUriError.missingName);
    }

    final algorithmName = query['algorithm'];
    final algorithm = algorithmName == null ? OtpSecret.defaultAlgorithm : OtpAlgorithm.tryParse(algorithmName);
    final digits = _parseInt(query['digits'], OtpSecret.defaultDigits);
    final period = _parseInt(query['period'], OtpSecret.defaultPeriod);
    if (algorithm == null || digits == null || !_supportedDigits.contains(digits) || period == null || period <= 0) {
      throw const OtpAuthUriException(OtpAuthUriError.unsupportedParameters);
    }

    return OtpSecret(
      id: const Uuid().v4(),
      issuer: issuer,
      account: account,
      secret: OtpSecretKey.normalize(secret),
      period: period,
      digits: digits,
      algorithm: algorithm,
    );
  }

  /// Splits `Issuer:account` into its parts; a label without a colon is only an account.
  (String issuer, String account) _splitLabel(String label) {
    final separator = label.indexOf(':');
    if (separator < 0) return ('', label.trim());
    return (label.substring(0, separator).trim(), label.substring(separator + 1).trim());
  }

  /// Returns [fallback] when [value] is absent and null when it is present but not a whole number.
  int? _parseInt(String? value, int fallback) => value == null ? fallback : int.tryParse(value);
}
