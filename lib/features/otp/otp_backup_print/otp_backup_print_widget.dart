import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_presenter.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class OtpBackupPrintWidget extends StatefulWidget with MaybeHasPresenter<OtpBackupPrintPresenter> {
  const OtpBackupPrintWidget({this.presenter, super.key});

  @override
  final OtpBackupPrintPresenter? presenter;

  @override
  State<OtpBackupPrintWidget> createState() => _OtpBackupPrintWidgetState();
}

class _OtpBackupPrintWidgetState extends State<OtpBackupPrintWidget>
    with PresenterStateMixin<OtpBackupPrintState, OtpBackupPrintPresenter, OtpBackupPrintWidget> {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final l10n = context.l10n;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.backup, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          ListTile(
            enabled: state.canPrint,
            leading: Icon(Icons.print_outlined, color: state.canPrint ? colorScheme.primary : null),
            title: Text(l10n.printBackupSheet),
            subtitle: Text(state.canPrint ? l10n.printBackupSheetSubtitle : l10n.printBackupSheetNoAccounts),
            trailing: const Icon(Icons.chevron_right),
            tileColor: colorScheme.surfaceContainerHigh,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            onTap: presenter.onPrintBackupPressed,
          ),
        ],
      );
    },
  );
}
