import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/otp_list/domain/repository/otp_list_repository.dart';
import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:otp/otp.dart';
import 'package:rxdart/rxdart.dart';

/// Streams the entries to show for the stored secrets, with their current codes.
class WatchOtpListUseCase {
  const WatchOtpListUseCase(this._repository);

  final OtpListRepository _repository;

  Stream<Iterable<OtpDisplayable>> call() {
    const eq = IterableEquality();

    return Rx.combineLatest2(_repository.getOtpSecretsStream(), _everySecond(), (secrets, _) => secrets)
        .map((secrets) {
          final now = clock.now();
          return secrets.map((secret) => _toDisplayable(secret, now)).toList();
        })
        .distinct((prev, next) => eq.equals(prev, next));
  }

  /// Emits when listened to and then as every second of the clock begins, which is when a code can change.
  Stream<void> _everySecond() =>
      Rx.repeat<void>((_) => TimerStream(null, Duration(milliseconds: 1000 - clock.now().millisecond))).startWith(null);

  OtpDisplayable _toDisplayable(OtpSecret secret, DateTime now) {
    final code = OTP.generateTOTPCodeString(
      secret.secret.replaceAll(' ', '').toUpperCase(),
      now.millisecondsSinceEpoch,
      interval: secret.period,
      length: secret.digits,
      algorithm: switch (secret.algorithm) {
        OtpAlgorithm.sha1 => Algorithm.SHA1,
        OtpAlgorithm.sha256 => Algorithm.SHA256,
        OtpAlgorithm.sha512 => Algorithm.SHA512,
      },
      isGoogle: true,
    );
    // A secret without an issuer is listed under its account name.
    final hasIssuer = secret.issuer.isNotEmpty;
    return OtpDisplayable(
      id: secret.id,
      name: hasIssuer ? secret.issuer : secret.account,
      account: hasIssuer ? secret.account : '',
      code: code,
      createdAt: secret.codeCreatedAt(now),
      expiresAt: secret.codeExpiresAt(now),
    );
  }
}
