import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/use_case/watch_otp_list_use_case.dart';
import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

const _sha1Key = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';
const _sha256Key = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZA';
const _sha512Key =
    'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQGEZDGNA';

OtpSecret _secret({
  String issuer = 'GitHub',
  String account = '',
  String key = _sha1Key,
  OtpAlgorithm algorithm = OtpAlgorithm.sha1,
  int digits = 8,
}) => OtpSecret(
  id: 'id',
  issuer: issuer,
  account: account,
  secret: key,
  period: 30,
  digits: digits,
  algorithm: algorithm,
);

void main() {
  late MockOtpListRepository repository;

  setUp(() => repository = MockOtpListRepository());

  Future<OtpDisplayable> firstEntry(OtpSecret secret, {int secondsSinceEpoch = 59}) async {
    when(() => repository.getOtpSecretsStream()).thenAnswer((_) => Stream.value([secret]));
    final time = DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000, isUtc: true);
    final entries = await withClock(Clock.fixed(time), () => WatchOtpListUseCase(repository)().first);
    return entries.single;
  }

  group('generates the RFC 6238 test codes', () {
    final vectors = [
      (key: _sha1Key, algorithm: OtpAlgorithm.sha1, seconds: 59, code: '94287082'),
      (key: _sha256Key, algorithm: OtpAlgorithm.sha256, seconds: 59, code: '46119246'),
      (key: _sha512Key, algorithm: OtpAlgorithm.sha512, seconds: 59, code: '90693936'),
      (key: _sha1Key, algorithm: OtpAlgorithm.sha1, seconds: 1111111109, code: '07081804'),
      (key: _sha256Key, algorithm: OtpAlgorithm.sha256, seconds: 1111111109, code: '68084774'),
      (key: _sha512Key, algorithm: OtpAlgorithm.sha512, seconds: 1111111109, code: '25091201'),
    ];

    for (final vector in vectors) {
      test('${vector.algorithm.name} at ${vector.seconds}s', () async {
        final otp = await firstEntry(
          _secret(key: vector.key, algorithm: vector.algorithm),
          secondsSinceEpoch: vector.seconds,
        );

        expect(otp.code, vector.code);
      });
    }
  });

  test('reports the period the code belongs to', () async {
    final otp = await firstEntry(_secret());

    expect(otp.createdAt.millisecondsSinceEpoch, 30000);
    expect(otp.expiresAt.millisecondsSinceEpoch, 60000);
  });

  test('keeps only the requested number of digits', () async {
    final otp = await firstEntry(_secret(digits: 6));

    expect(otp.code, '287082');
  });

  test('ignores spaces and letter case in the key', () async {
    final otp = await firstEntry(_secret(key: 'gezd gnbv gy3t qojq gezd gnbv gy3t qojq'));

    expect(otp.code, '94287082');
  });

  test('lists a secret under its issuer, with the account beside it', () async {
    final otp = await firstEntry(_secret(account: 'alice@example.com'));

    expect((otp.id, otp.name, otp.account), ('id', 'GitHub', 'alice@example.com'));
  });

  test('lists a secret without an issuer under its account', () async {
    final otp = await firstEntry(_secret(issuer: '', account: 'alice@example.com'));

    expect((otp.name, otp.account), ('alice@example.com', ''));
  });

  group('as time passes', () {
    final start = DateTime.fromMillisecondsSinceEpoch(59400, isUtc: true);

    test('shows the next code as soon as the current one expires', () {
      fakeAsync((async) {
        when(() => repository.getOtpSecretsStream()).thenAnswer((_) => Stream.value([_secret()]));
        final codes = <String>[];
        WatchOtpListUseCase(repository)().listen((entries) => codes.add(entries.single.code));

        async.elapse(const Duration(milliseconds: 599));
        expect(codes, ['94287082']);

        async.elapse(const Duration(milliseconds: 1));
        expect(codes, ['94287082', '37359152']);
      }, initialTime: start);
    });

    test('stops the clock when nobody listens any more', () {
      fakeAsync((async) {
        when(() => repository.getOtpSecretsStream()).thenAnswer((_) => Stream.value([_secret()]));
        final subscription = WatchOtpListUseCase(repository)().listen((_) {});
        async.elapse(const Duration(seconds: 5));

        subscription.cancel();
        async.flushMicrotasks();

        expect(async.pendingTimers, isEmpty);
      }, initialTime: start);
    });
  });
}
