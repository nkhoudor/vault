import 'package:app_core/features/otp/domain/model/otp_secret.dart';

abstract class OtpListRepository {
  Stream<Iterable<OtpSecret>> getOtpSecretsStream();

  /// Puts [code] on the system clipboard.
  Future<void> copyCode(String code);

  /// Removes the secret with this [id].
  Future<void> removeSecret(String id);
}
