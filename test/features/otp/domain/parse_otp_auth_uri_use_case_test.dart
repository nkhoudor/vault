import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_auth_uri_exception.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/use_case/parse_otp_auth_uri_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../otp_secret_matcher.dart';

void main() {
  const parse = ParseOtpAuthUriUseCase();

  Matcher throwsUriError(OtpAuthUriError error) =>
      throwsA(isA<OtpAuthUriException>().having((e) => e.error, 'error', error));

  group('a valid link', () {
    test('reads every field', () {
      final secret = parse(
        'otpauth://totp/GitHub:alice%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub&algorithm=SHA256&digits=8&period=60',
      );

      expect(
        secret,
        equalsIgnoringId(
          const OtpSecret(
            id: '',
            issuer: 'GitHub',
            account: 'alice@example.com',
            secret: 'JBSWY3DPEHPK3PXP',
            period: 60,
            digits: 8,
            algorithm: OtpAlgorithm.sha256,
          ),
        ),
      );
    });

    test('gives every secret its own id', () {
      const link = 'otpauth://totp/GitHub:alice?secret=JBSWY3DPEHPK3PXP';

      expect(parse(link).id, isNotEmpty);
      expect(parse(link).id, isNot(parse(link).id));
    });

    test('falls back to SHA1, 6 digits and 30 seconds', () {
      final secret = parse('otpauth://totp/GitHub:alice?secret=JBSWY3DPEHPK3PXP');

      expect((secret.algorithm, secret.digits, secret.period), (OtpAlgorithm.sha1, 6, 30));
    });

    test('takes the issuer from the label when there is no issuer parameter', () {
      final secret = parse('otpauth://totp/Example%20Co:%20alice?secret=JBSWY3DPEHPK3PXP');

      expect((secret.issuer, secret.account), ('Example Co', 'alice'));
    });

    test('prefers the issuer parameter over the label prefix', () {
      final secret = parse('otpauth://totp/Old:alice?secret=JBSWY3DPEHPK3PXP&issuer=New');

      expect((secret.issuer, secret.account), ('New', 'alice'));
    });

    test('treats a label without a colon as the account', () {
      final secret = parse('otpauth://totp/alice@example.com?secret=JBSWY3DPEHPK3PXP');

      expect((secret.issuer, secret.account), ('', 'alice@example.com'));
    });

    test('accepts an issuer without an account', () {
      final secret = parse('otpauth://totp/?secret=JBSWY3DPEHPK3PXP&issuer=GitHub');

      expect((secret.issuer, secret.account), ('GitHub', ''));
    });

    test('normalizes the key and ignores the case of scheme, type and algorithm', () {
      final secret = parse('  OTPAUTH://TOTP/a?secret=jbswy3dpehpk3pxp%3D%3D&algorithm=sha512  ');

      expect((secret.secret, secret.algorithm), ('JBSWY3DPEHPK3PXP', OtpAlgorithm.sha512));
    });
  });

  group('rejects', () {
    test('text that is not an otpauth link', () {
      expect(() => parse('https://example.com'), throwsUriError(OtpAuthUriError.notOtpAuth));
      expect(() => parse('WIFI:S:home;T:WPA;P:secret;;'), throwsUriError(OtpAuthUriError.notOtpAuth));
      expect(() => parse(''), throwsUriError(OtpAuthUriError.notOtpAuth));
      expect(() => parse('otpauth://totp/a?secret=MFRGGZDF&issuer=%ff'), throwsUriError(OtpAuthUriError.notOtpAuth));
    });

    test('counter-based and unknown types', () {
      expect(
        () => parse('otpauth://hotp/a?secret=JBSWY3DPEHPK3PXP&counter=1'),
        throwsUriError(OtpAuthUriError.unsupportedType),
      );
      expect(() => parse('otpauth://steam/a?secret=JBSWY3DPEHPK3PXP'), throwsUriError(OtpAuthUriError.unsupportedType));
    });

    test('a missing or malformed key', () {
      expect(() => parse('otpauth://totp/a'), throwsUriError(OtpAuthUriError.invalidSecret));
      expect(() => parse('otpauth://totp/a?secret='), throwsUriError(OtpAuthUriError.invalidSecret));
      expect(() => parse('otpauth://totp/a?secret=not-base32!'), throwsUriError(OtpAuthUriError.invalidSecret));
      expect(() => parse('otpauth://totp/a?secret=%zz'), throwsUriError(OtpAuthUriError.invalidSecret));
    });

    test('a link with neither issuer nor account', () {
      expect(() => parse('otpauth://totp/?secret=JBSWY3DPEHPK3PXP'), throwsUriError(OtpAuthUriError.missingName));
    });

    test('settings the app cannot generate codes for', () {
      const base = 'otpauth://totp/a?secret=JBSWY3DPEHPK3PXP';

      for (final parameters in ['algorithm=MD5', 'digits=5', 'digits=six', 'period=0', 'period=-30', 'period=x']) {
        expect(
          () => parse('$base&$parameters'),
          throwsUriError(OtpAuthUriError.unsupportedParameters),
          reason: parameters,
        );
      }
    });
  });
}
