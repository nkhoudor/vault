import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:flutter/material.dart';

/// The ways of adding an account offered by [OtpAddOptionsSheet].
enum OtpAddOption { scanQrCode, enterManually }

/// Bottom sheet that asks how the user wants to add an account.
///
/// Pops with the chosen [OtpAddOption], or with nothing when dismissed.
class OtpAddOptionsSheet extends StatelessWidget {
  const OtpAddOptionsSheet({super.key});

  static Future<OtpAddOption?> show(BuildContext context) => showModalBottomSheet<OtpAddOption>(
    context: context,
    showDragHandle: true,
    builder: (_) => const OtpAddOptionsSheet(),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: Text(l10n.addOptionScanQrCode),
            onTap: () => Navigator.of(context).pop(OtpAddOption.scanQrCode),
          ),
          ListTile(
            leading: const Icon(Icons.keyboard_outlined),
            title: Text(l10n.addOptionEnterManually),
            onTap: () => Navigator.of(context).pop(OtpAddOption.enterManually),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
