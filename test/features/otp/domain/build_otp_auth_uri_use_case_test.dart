import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/use_case/build_otp_auth_uri_use_case.dart';
import 'package:app_core/features/otp/domain/use_case/parse_otp_auth_uri_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../otp_secret_matcher.dart';

OtpSecret _secret({
  String issuer = 'GitHub',
  String account = 'alex@example.com',
  int period = 30,
  int digits = 6,
  OtpAlgorithm algorithm = OtpAlgorithm.sha1,
}) => OtpSecret(
  id: 'id',
  issuer: issuer,
  account: account,
  secret: 'JBSWY3DPEHPK3PXP',
  period: period,
  digits: digits,
  algorithm: algorithm,
);

void main() {
  const build = BuildOtpAuthUriUseCase();
  const parse = ParseOtpAuthUriUseCase();

  test('writes the label, the key and every setting', () {
    expect(
      build(_secret()),
      'otpauth://totp/GitHub:alex%40example.com'
      '?secret=JBSWY3DPEHPK3PXP&issuer=GitHub&algorithm=SHA1&digits=6&period=30',
    );
  });

  test('encodes spaces as %20, which every authenticator app reads', () {
    final uri = build(_secret(issuer: 'Acme & Co', account: 'alex smith'));

    expect(uri, startsWith('otpauth://totp/Acme%20%26%20Co:alex%20smith?'));
    expect(uri, contains('issuer=Acme%20%26%20Co'));
  });

  group('the app reads back what it wrote', () {
    final secrets = {
      'an issuer and an account': _secret(),
      'an issuer alone': _secret(account: ''),
      'an account alone': _secret(issuer: ''),
      'an account with a colon alone': _secret(issuer: '', account: 'team:alex'),
      'unusual settings': _secret(period: 60, digits: 8, algorithm: OtpAlgorithm.sha512),
      'names with symbols': _secret(issuer: 'Acme & Co: West', account: 'a+b@example.com'),
      'names outside Latin': _secret(issuer: 'Яндекс', account: 'имя@example.com'),
    };

    for (final MapEntry(key: name, value: secret) in secrets.entries) {
      test(name, () => expect(parse(build(secret)), equalsIgnoringId(secret)));
    }
  });
}
