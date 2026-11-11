import 'package:app_core/core/logs.dart';
import 'package:app_core/features/otp/domain/model/otp_auth_uri_exception.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/use_case/parse_otp_auth_uri_use_case.dart';
import 'package:app_core/features/otp/otp_scanner/domain/repository/otp_scanner_repository.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_navigator.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScannerPresenter extends Cubit<OtpScannerState> {
  OtpScannerPresenter(super.model, this._navigator, this._repository, this._parseOtpAuthUri);

  final OtpScannerNavigator _navigator;
  final OtpScannerRepository _repository;
  final ParseOtpAuthUriUseCase _parseOtpAuthUri;

  /// Called for every code the camera reads, which is many times a second while one is in view.
  Future<void> onCodeDetected(String code) async {
    if (state.isSaving) return;

    final OtpSecret secret;
    try {
      secret = _parseOtpAuthUri(code);
    } on OtpAuthUriException catch (e) {
      tryEmit(state.copyWith(codeError: e.error, saveFailed: false));
      return;
    }

    tryEmit(state.copyWith(codeError: null, saveFailed: false, isSaving: true));
    try {
      await _repository.addSecret(secret);
    } on Exception catch (e, stackTrace) {
      Logs.e('Could not save the scanned account', e, stackTrace);
      tryEmit(state.copyWith(isSaving: false, saveFailed: true));
      return;
    }
    await _navigator.navigateBack();
  }

  /// Called when the camera cannot start, for example because the user refused access to it.
  void onCameraFailed({required bool isPermissionDenied}) => tryEmit(
    state.copyWith(
      cameraIssue: isPermissionDenied ? OtpScannerCameraIssue.permissionDenied : OtpScannerCameraIssue.unavailable,
    ),
  );

  Future<void> onEnterManuallyPressed() => _navigator.navigateToOtpManualEntry();
}
