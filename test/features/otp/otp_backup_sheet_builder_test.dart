import 'dart:convert';

import 'package:app_core/features/otp/data/backup/otp_backup_sheet_builder.dart';
import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/use_case/build_otp_auth_uri_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import 'backup_sheet_texts.dart';

OtpSecret _secret(int index) => OtpSecret(
  id: '$index',
  issuer: 'Service $index',
  account: 'alex@example.com',
  secret: 'JBSWY3DPEHPK3PXP',
  period: 30,
  digits: 6,
  algorithm: OtpAlgorithm.sha1,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const build = OtpBackupSheetBuilder(BuildOtpAuthUriUseCase());

  Future<int> pageCount(int accounts) async {
    final pdf = latin1.decode(await build([for (var i = 0; i < accounts; i++) _secret(i)], backupSheetTexts));
    return RegExp(r'/Type\s*/Page\b').allMatches(pdf).length;
  }

  group('keyLines', () {
    test('splits a key into groups of four, four groups to a line', () {
      expect(OtpBackupSheetBuilder.keyLines('JBSWY3DPEHPK3PXP'), ['JBSW Y3DP EHPK 3PXP']);
      expect(OtpBackupSheetBuilder.keyLines('JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP'), [
        'JBSW Y3DP EHPK 3PXP',
        'JBSW Y3DP EHPK 3PXP',
      ]);
    });

    test('keeps a shorter last group', () {
      expect(OtpBackupSheetBuilder.keyLines('JBSWY3DPEH'), ['JBSW Y3DP EH']);
    });

    test('puts six groups on a line for a very long key', () {
      final lines = OtpBackupSheetBuilder.keyLines('A' * 104);

      expect(lines.first, List.filled(6, 'AAAA').join(' '));
      expect(lines, hasLength(5));
    });
  });

  test('fits fifteen accounts on a page', () async {
    expect(await pageCount(1), 1);
    expect(await pageCount(15), 1);
    expect(await pageCount(16), 2);
    expect(await pageCount(31), 3);
  });
}
