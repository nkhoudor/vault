import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_add_button/widgets/otp_add_option_tile.dart';
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.addAccount, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            OtpAddOptionTile(
              icon: Icons.qr_code_scanner,
              title: l10n.addOptionScanQrCode,
              subtitle: l10n.addOptionScanQrCodeHint,
              onTap: () => Navigator.of(context).pop(OtpAddOption.scanQrCode),
            ),
            const SizedBox(height: 10),
            OtpAddOptionTile(
              icon: Icons.keyboard_outlined,
              title: l10n.addOptionEnterManually,
              subtitle: l10n.addOptionEnterManuallyHint,
              onTap: () => Navigator.of(context).pop(OtpAddOption.enterManually),
            ),
          ],
        ),
      ),
    );
  }
}
