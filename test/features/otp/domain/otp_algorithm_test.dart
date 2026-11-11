import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads the names otpauth links use', () {
    expect(OtpAlgorithm.tryParse('SHA1'), OtpAlgorithm.sha1);
    expect(OtpAlgorithm.tryParse('SHA256'), OtpAlgorithm.sha256);
    expect(OtpAlgorithm.tryParse('SHA512'), OtpAlgorithm.sha512);
  });

  test('ignores letter case', () {
    expect(OtpAlgorithm.tryParse('sha256'), OtpAlgorithm.sha256);
    expect(OtpAlgorithm.tryParse('Sha512'), OtpAlgorithm.sha512);
  });

  test('returns null for an algorithm the app does not have', () {
    expect(OtpAlgorithm.tryParse('MD5'), isNull);
    expect(OtpAlgorithm.tryParse(''), isNull);
  });
}
