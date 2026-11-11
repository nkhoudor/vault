import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_presenter.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_state.dart';
import 'package:app_core/features/otp/otp_add_button/widgets/otp_add_options_sheet.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class OtpAddButtonWidget extends StatefulWidget with MaybeHasPresenter<OtpAddButtonPresenter> {
  const OtpAddButtonWidget({this.presenter, super.key});

  @override
  final OtpAddButtonPresenter? presenter;

  @override
  State<OtpAddButtonWidget> createState() => _OtpAddButtonWidgetState();
}

class _OtpAddButtonWidgetState extends State<OtpAddButtonWidget>
    with PresenterStateMixin<OtpAddButtonState, OtpAddButtonPresenter, OtpAddButtonWidget> {
  Future<void> _onAddPressed() async {
    final option = await OtpAddOptionsSheet.show(context);
    switch (option) {
      case OtpAddOption.scanQrCode:
        await presenter.onScanQrCodeTapped();
      case OtpAddOption.enterManually:
        await presenter.onEnterManuallyTapped();
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _onAddPressed,
      tooltip: context.l10n.addAccount,
      child: const Icon(Icons.add),
    );
  }
}
