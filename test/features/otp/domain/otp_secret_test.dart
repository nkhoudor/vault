import 'dart:convert';

import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:flutter_test/flutter_test.dart';

const _secret = OtpSecret(
  id: 'id',
  issuer: 'GitHub',
  secret: 'KEY',
  period: 30,
  digits: 6,
  algorithm: OtpAlgorithm.sha1,
);

DateTime _at(int seconds) => DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

void main() {
  test('a code starts at the beginning of its period', () {
    expect(_secret.codeCreatedAt(_at(59)), _at(30));
  });

  test('a code expires when its period ends', () {
    expect(_secret.codeExpiresAt(_at(59)), _at(60));
  });

  test('the first second of a period belongs to the new code', () {
    expect(_secret.codeCreatedAt(_at(60)), _at(60));
    expect(_secret.codeExpiresAt(_at(60)), _at(90));
  });

  test('uses the period of the secret', () {
    expect(_secret.copyWith(period: 60).codeExpiresAt(_at(59)), _at(60));
    expect(_secret.copyWith(period: 60).codeCreatedAt(_at(59)), _at(0));
  });

  for (final algorithm in OtpAlgorithm.values) {
    test('keeps ${algorithm.name} when stored and read back', () {
      final stored = jsonEncode(_secret.copyWith(algorithm: algorithm).toJson());

      expect(OtpSecret.fromJson(jsonDecode(stored) as Map<String, dynamic>).algorithm, algorithm);
    });
  }
}
