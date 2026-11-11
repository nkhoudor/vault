import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_presenter.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
import 'package:app_core/features/otp/otp_scanner/widgets/otp_scanner_camera.dart';
import 'package:app_core/features/otp/otp_scanner/widgets/otp_scanner_camera_error.dart';
import 'package:app_core/features/otp/otp_scanner/widgets/otp_scanner_status.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class OtpScannerWidget extends StatefulWidget with MaybeHasPresenter<OtpScannerPresenter> {
  const OtpScannerWidget({this.presenter, super.key});

  @override
  final OtpScannerPresenter? presenter;

  @override
  State<OtpScannerWidget> createState() => _OtpScannerWidgetState();
}

class _OtpScannerWidgetState extends State<OtpScannerWidget>
    with PresenterStateMixin<OtpScannerState, OtpScannerPresenter, OtpScannerWidget> {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) {
      final cameraIssue = state.cameraIssue;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: cameraIssue == null
                ? OtpScannerCamera(onCodeDetected: presenter.onCodeDetected, onCameraFailed: presenter.onCameraFailed)
                : OtpScannerCameraError(issue: cameraIssue),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Center(child: OtpScannerStatus(state: state)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: presenter.onEnterManuallyPressed,
                    child: Text(context.l10n.addOptionEnterManually),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
