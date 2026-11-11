import 'package:app_core/features/otp/domain/model/otp_secret.dart';

abstract class OtpScannerRepository {
  Future<void> addSecret(OtpSecret secret);
}
