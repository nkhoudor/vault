import 'package:app_core/features/otp/domain/model/otp_secret_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp/otp.dart';

void main() {
  group('OtpSecretKey.normalize', () {
    test('upper-cases and removes spaces, dashes and padding', () {
      expect(OtpSecretKey.normalize(' jbsw y3dp-ehpk 3pxp== '), 'JBSWY3DPEHPK3PXP');
    });
  });

  group('OtpSecretKey.isValid', () {
    test('accepts Base32 in the forms services print it', () {
      expect(OtpSecretKey.isValid('JBSWY3DPEHPK3PXP'), isTrue);
      expect(OtpSecretKey.isValid('jbsw y3dp ehpk 3pxp'), isTrue);
      expect(OtpSecretKey.isValid('JBSWY3DPEHPK3PXP===='), isTrue);
      expect(OtpSecretKey.isValid('MFRGGZDF'), isTrue);
    });

    test('rejects empty input', () {
      expect(OtpSecretKey.isValid(''), isFalse);
      expect(OtpSecretKey.isValid('  - '), isFalse);
    });

    test('rejects characters outside the Base32 alphabet', () {
      expect(OtpSecretKey.isValid('JBSWY3DPEHPK3PX1'), isFalse);
      expect(OtpSecretKey.isValid('JBSWY3DP!'), isFalse);
      expect(OtpSecretKey.isValid('ключ'), isFalse);
    });

    test('rejects lengths that do not decode to whole bytes', () {
      expect(OtpSecretKey.isValid('A'), isFalse);
      expect(OtpSecretKey.isValid('ABC'), isFalse);
      expect(OtpSecretKey.isValid('ABCDEF'), isFalse);
    });

    test('every key it accepts can generate a code', () {
      for (final key in ['MFRGGZDF', 'MFRGG', 'MFRGGZDFMZTWQ', 'JBSWY3DPEHPK3PXP', 'MF']) {
        expect(OtpSecretKey.isValid(key), isTrue, reason: key);
        final code = OTP.generateTOTPCodeString(key, 0, algorithm: Algorithm.SHA1, isGoogle: true);
        expect(code, hasLength(6), reason: key);
      }
    });
  });
}
