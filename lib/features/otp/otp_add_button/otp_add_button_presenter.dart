import 'package:app_core/features/otp/otp_add_button/otp_add_button_navigator.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpAddButtonPresenter extends Cubit<OtpAddButtonState> {
  OtpAddButtonPresenter(super.model, this._navigator);

  final OtpAddButtonNavigator _navigator;

  Future<void> onScanQrCodeTapped() => _navigator.navigateToOtpScanner();

  Future<void> onEnterManuallyTapped() => _navigator.navigateToOtpManualEntry();
}
