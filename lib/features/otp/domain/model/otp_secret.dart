import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../../generated/features/otp/domain/model/otp_secret.freezed.dart';
part '../../../../generated/features/otp/domain/model/otp_secret.g.dart';

@freezed
abstract class OtpSecret with _$OtpSecret {
  const factory OtpSecret({
    required String id,
    required String issuer,
    required String secret,
    required int period,
    required int digits,
    required OtpAlgorithm algorithm,

    /// The user's account at the [issuer], e.g. an email address.
    @Default('') String account,
  }) = _OtpSecret;

  factory OtpSecret.fromJson(Map<String, dynamic> json) => _$OtpSecretFromJson(json);

  const OtpSecret._();

  /// Values a TOTP setup uses when it does not say otherwise.
  static const defaultPeriod = 30;
  static const defaultDigits = 6;
  static const defaultAlgorithm = OtpAlgorithm.sha1;

  /// When the code valid at [now] started being valid.
  DateTime codeCreatedAt(DateTime now) {
    final seconds = now.millisecondsSinceEpoch ~/ 1000;
    return DateTime.fromMillisecondsSinceEpoch((seconds - seconds % period) * 1000);
  }

  /// When the code valid at [now] stops being valid.
  DateTime codeExpiresAt(DateTime now) => codeCreatedAt(now).add(Duration(seconds: period));

  bool isDuplicateOf(OtpSecret other) => copyWith(id: other.id) == other;
}
