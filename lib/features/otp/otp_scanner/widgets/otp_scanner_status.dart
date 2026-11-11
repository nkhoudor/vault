import 'package:app_core/features/otp/domain/model/otp_auth_uri_exception.dart';
import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
import 'package:flutter/material.dart';

/// The line under the camera preview: a hint while scanning, or why the last code was rejected.
///
/// Empty when the camera cannot be used and there is nothing else to report.
class OtpScannerStatus extends StatelessWidget {
  const OtpScannerStatus({required this.state, super.key});

  final OtpScannerState state;

  String? _errorMessage(OtpLocalizations l10n) {
    if (state.saveFailed) return l10n.saveFailed;
    return switch (state.codeError) {
      null => null,
      OtpAuthUriError.notOtpAuth => l10n.scannerErrorNotOtpAuth,
      OtpAuthUriError.unsupportedType => l10n.scannerErrorUnsupportedType,
      OtpAuthUriError.invalidSecret => l10n.scannerErrorInvalidSecret,
      OtpAuthUriError.missingName => l10n.scannerErrorMissingName,
      OtpAuthUriError.unsupportedParameters => l10n.scannerErrorUnsupportedParameters,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final errorMessage = _errorMessage(l10n);

    if (state.isSaving) {
      return const Center(child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 3)));
    }

    // Without a camera there is nothing to point; the reason is shown in place of the preview.
    if (errorMessage == null && state.cameraIssue != null) return const SizedBox.shrink();

    return Text(
      errorMessage ?? l10n.scannerHint,
      style: theme.textTheme.bodyLarge?.copyWith(color: errorMessage == null ? null : theme.colorScheme.error),
      textAlign: TextAlign.center,
    );
  }
}
