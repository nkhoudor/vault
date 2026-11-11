import 'dart:async';
import 'dart:convert';

import 'package:app_core/core/clipboard/system_clipboard.dart';
import 'package:app_core/core/storage/secure_storage.dart';
import 'package:app_core/features/otp/data/repository/otp_repository_impl.dart';
import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSecureStorage implements SecureStorage {
  String? value;
  final _changes = StreamController<String?>.broadcast();

  @override
  Future<String?> getString(String key) async => value;

  @override
  Future<void> setString(String key, String value) async {
    this.value = value;
    _changes.add(value);
  }

  @override
  Stream<String?> getStringStream(String key) async* {
    yield value;
    yield* _changes.stream;
  }
}

class _FakeSystemClipboard implements SystemClipboard {
  String? text;

  @override
  Future<void> setText(String text) async => this.text = text;
}

OtpSecret _secret(String issuer, {String account = ''}) => OtpSecret(
  id: issuer.toLowerCase(),
  issuer: issuer,
  account: account,
  secret: 'JBSWY3DPEHPK3PXP',
  period: 30,
  digits: 6,
  algorithm: OtpAlgorithm.sha1,
);

String _encode(List<OtpSecret> secrets) => jsonEncode(secrets.map((s) => s.toJson()).toList());

void main() {
  late _FakeSecureStorage storage;
  late _FakeSystemClipboard clipboard;
  late OtpRepositoryImpl repository;

  List<OtpSecret> stored() => [
    for (final s in jsonDecode(storage.value!) as List) OtpSecret.fromJson(s as Map<String, dynamic>),
  ];

  List<String> storedIssuers() => [for (final secret in stored()) secret.issuer];

  setUp(() {
    storage = _FakeSecureStorage()..value = _encode([_secret('A'), _secret('B'), _secret('C')]);
    clipboard = _FakeSystemClipboard();
    repository = OtpRepositoryImpl(storage, clipboard);
  });

  group('addSecret', () {
    test('appends to the stored secrets', () async {
      await repository.addSecret(_secret('D'));

      expect(stored(), [_secret('A'), _secret('B'), _secret('C'), _secret('D')]);
    });

    test('does not store an account that is already stored', () async {
      await repository.addSecret(_secret('B').copyWith(id: 'scanned-again'));

      expect(stored(), [_secret('A'), _secret('B'), _secret('C')]);
    });

    test('stores the same key again for another account', () async {
      await repository.addSecret(_secret('B', account: 'second@example.com').copyWith(id: 'b2'));

      expect(storedIssuers(), ['A', 'B', 'C', 'B']);
    });

    test('stores the first secret when nothing is stored yet', () async {
      storage.value = null;

      await repository.addSecret(_secret('A'));

      expect(storedIssuers(), ['A']);
    });
  });

  group('removeSecret', () {
    test('removes only the secret with the id', () async {
      await repository.removeSecret('b');

      expect(storedIssuers(), ['A', 'C']);
    });

    test('removes the right secret when the list changed after the id was read', () async {
      await repository.removeSecret('a');
      await repository.removeSecret('b');

      expect(storedIssuers(), ['C']);
    });

    test('removes nothing for an id that is not stored', () async {
      await repository.removeSecret('missing');

      expect(storedIssuers(), ['A', 'B', 'C']);
    });
  });

  test('copyCode puts the code on the clipboard', () async {
    await repository.copyCode('123456');

    expect(clipboard.text, '123456');
  });

  test('getOtpSecretsStream emits the stored secrets', () async {
    expect(await repository.getOtpSecretsStream().first, [_secret('A'), _secret('B'), _secret('C')]);
  });
}
