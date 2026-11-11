import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:flutter/material.dart';

/// Asks the user to confirm deleting the OTP called [name].
///
/// Pops with `true` when the user confirms.
class OtpDeleteDialog extends StatelessWidget {
  const OtpDeleteDialog({required this.name, super.key});

  final String name;

  static Future<bool> show(BuildContext context, {required String name}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => OtpDeleteDialog(name: name),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 32),
      title: Text(l10n.deleteOtpTitle),
      content: Text(l10n.deleteOtpMessage(name)),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
