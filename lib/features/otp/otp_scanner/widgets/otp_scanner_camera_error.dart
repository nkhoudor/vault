import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
import 'package:flutter/material.dart';

/// Shown in place of the camera preview when the camera cannot be used.
class OtpScannerCameraError extends StatelessWidget {
  const OtpScannerCameraError({required this.issue, super.key});

  final OtpScannerCameraIssue issue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.no_photography_outlined, size: 48, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                switch (issue) {
                  OtpScannerCameraIssue.permissionDenied => l10n.scannerCameraDenied,
                  OtpScannerCameraIssue.unavailable => l10n.scannerCameraUnavailable,
                },
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
