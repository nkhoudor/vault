import 'package:app_core/features/otp/domain/model/otp_secret.dart';

abstract class OtpBackupPrintRepository {
  Stream<Iterable<OtpSecret>> getOtpSecretsStream();
}
