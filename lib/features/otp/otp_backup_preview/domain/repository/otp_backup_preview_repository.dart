import 'package:app_core/features/otp/domain/model/otp_backup_sheet.dart';
import 'package:app_core/features/otp/domain/model/otp_backup_sheet_texts.dart';

abstract class OtpBackupPreviewRepository {
  /// Lays out a sheet of every stored account, worded with [texts].
  Future<OtpBackupSheet> buildBackupSheet(OtpBackupSheetTexts texts);

  /// Offers [sheet] for printing or saving.
  Future<void> shareBackupSheet(OtpBackupSheet sheet);
}
