import 'package:app_core/features/otp/domain/model/otp_secret.dart';

/// Turns an [OtpSecret] into the `otpauth://totp/...` link authenticator apps read from a setup QR code.
///
/// The opposite of `ParseOtpAuthUriUseCase`. Every setting is written out, so the link does not depend on the
/// defaults of the app that reads it.
class BuildOtpAuthUriUseCase {
  const BuildOtpAuthUriUseCase();

  String call(OtpSecret secret) {
    // An account with a colon and no issuer keeps an empty issuer in front, or its first part would be read as one.
    final label = [
      if (secret.issuer.isNotEmpty || secret.account.contains(':')) secret.issuer,
      if (secret.account.isNotEmpty) secret.account,
    ].map(Uri.encodeComponent).join(':');
    final parameters = {
      'secret': secret.secret,
      if (secret.issuer.isNotEmpty) 'issuer': secret.issuer,
      'algorithm': secret.algorithm.name.toUpperCase(),
      'digits': '${secret.digits}',
      'period': '${secret.period}',
    };
    final query = parameters.entries.map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}').join('&');

    return 'otpauth://totp/$label?$query';
  }
}
