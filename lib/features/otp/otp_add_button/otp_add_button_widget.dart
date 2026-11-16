import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_presenter.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_state.dart';
import 'package:app_core/features/otp/otp_add_button/widgets/otp_add_options_sheet.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class OtpAddButtonWidget extends StatefulWidget with MaybeHasPresenter<OtpAddButtonPresenter> {
  const OtpAddButtonWidget({this.presenter, this.expansion = 0, super.key});

  /// How much of the label is shown, from 0 (a round button with a plus) to 1 (the plus and the whole label).
  final double expansion;

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
    final label = context.l10n.addAccount;

    return Tooltip(
      message: label,
      child: FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size.square(52), padding: EdgeInsets.zero),
        onPressed: _onAddPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 24),
            ClipRect(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: widget.expansion,
                child: Opacity(
                  opacity: widget.expansion,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: ExcludeSemantics(child: Text(label, maxLines: 1, softWrap: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
