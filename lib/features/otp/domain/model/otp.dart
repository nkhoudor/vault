import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../../generated/features/otp/domain/model/otp.freezed.dart';
part '../../../../generated/features/otp/domain/model/otp.g.dart';

@freezed
abstract class OtpDisplayable with _$OtpDisplayable {
  const factory OtpDisplayable({
    required String id,
    required String name,
    required String code,
    required DateTime createdAt,
    required DateTime expiresAt,

    /// The account at the service called [name]; empty when unknown.
    @Default('') String account,
  }) = _OtpDisplayable;

  factory OtpDisplayable.fromJson(Map<String, dynamic> json) => _$OtpDisplayableFromJson(json);

  const OtpDisplayable._();

  /// [name] with the [account] when there is one, for places that must identify a single entry.
  String get label => account.isEmpty ? name : '$name ($account)';
}
