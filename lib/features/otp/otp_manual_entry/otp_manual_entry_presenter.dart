import 'package:app_core/core/logs.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/model/otp_secret_key.dart';
import 'package:app_core/features/otp/otp_manual_entry/domain/repository/otp_manual_entry_repository.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_navigator.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class OtpManualEntryPresenter extends Cubit<OtpManualEntryState> {
  OtpManualEntryPresenter(super.model, this._navigator, this._repository);

  final OtpManualEntryNavigator _navigator;
  final OtpManualEntryRepository _repository;

  void onIssuerChanged(String issuer) => tryEmit(state.copyWith(issuer: issuer));

  void onAccountChanged(String account) => tryEmit(state.copyWith(account: account));

  void onSecretKeyChanged(String secretKey) => tryEmit(state.copyWith(secretKey: secretKey));

  Future<void> onSavePressed() async {
    if (state.isSaving) return;
    if (!state.isValid) {
      tryEmit(state.copyWith(showErrors: true));
      return;
    }

    tryEmit(state.copyWith(isSaving: true, saveFailed: false));
    try {
      await _repository.addSecret(
        OtpSecret(
          id: const Uuid().v4(),
          issuer: state.issuer.trim(),
          account: state.account.trim(),
          secret: OtpSecretKey.normalize(state.secretKey),
          period: OtpSecret.defaultPeriod,
          digits: OtpSecret.defaultDigits,
          algorithm: OtpSecret.defaultAlgorithm,
        ),
      );
    } on Exception catch (e, stackTrace) {
      Logs.e('Could not save the account', e, stackTrace);
      tryEmit(state.copyWith(isSaving: false, saveFailed: true));
      return;
    }
    await _navigator.navigateBack();
  }
}
