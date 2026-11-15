import 'package:app_core/core/logs.dart';
import 'package:app_core/features/otp/domain/model/otp_backup_sheet_texts.dart';
import 'package:app_core/features/otp/otp_backup_preview/domain/repository/otp_backup_preview_repository.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_navigator.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpBackupPreviewPresenter extends Cubit<OtpBackupPreviewState> {
  OtpBackupPreviewPresenter(super.model, this._navigator, this._repository);

  //ignore: unused_field
  final OtpBackupPreviewNavigator _navigator;
  final OtpBackupPreviewRepository _repository;

  /// Lays the sheet out in the language of [texts].
  Future<void> onSheetTextsChanged(OtpBackupSheetTexts texts) async {
    tryEmit(const OtpBackupPreviewState());
    try {
      tryEmit(state.copyWith(sheet: await _repository.buildBackupSheet(texts)));
    } on Object catch (e, stackTrace) {
      Logs.e('Could not prepare the backup sheet', e, stackTrace);
      tryEmit(state.copyWith(previewFailed: true));
    }
  }

  Future<void> onPrintPressed() async {
    final sheet = state.sheet;
    if (sheet == null) return;

    tryEmit(state.copyWith(printFailed: false));
    try {
      await _repository.shareBackupSheet(sheet);
    } on Exception catch (e, stackTrace) {
      Logs.e('Could not print the backup sheet', e, stackTrace);
      tryEmit(state.copyWith(printFailed: true));
    }
  }
}
