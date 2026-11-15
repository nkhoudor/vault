import 'dart:async';

import 'package:app_core/features/otp/domain/model/otp_backup_sheet_texts.dart';
import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_presenter.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_state.dart';
import 'package:app_core/features/otp/otp_backup_preview/widgets/otp_backup_pages.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Shows the backup sheet before it is printed, with the button that offers it for printing or saving.
class OtpBackupPreviewWidget extends StatefulWidget with MaybeHasPresenter<OtpBackupPreviewPresenter> {
  const OtpBackupPreviewWidget({this.presenter, super.key});

  @override
  final OtpBackupPreviewPresenter? presenter;

  @override
  State<OtpBackupPreviewWidget> createState() => _OtpBackupPreviewWidgetState();
}

class _OtpBackupPreviewWidgetState extends State<OtpBackupPreviewWidget>
    with PresenterStateMixin<OtpBackupPreviewState, OtpBackupPreviewPresenter, OtpBackupPreviewWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.l10n;

    unawaited(
      presenter.onSheetTextsChanged(
        OtpBackupSheetTexts(
          title: l10n.backupSheetTitle,
          summary: (accountCount, date) =>
              l10n.backupSheetSummary(accountCount, DateFormat.yMMMd(l10n.localeName).format(date)),
          warning: l10n.backupSheetWarning,
          footer: l10n.backupSheetFooter,
          pageLabel: l10n.backupSheetPage,
          parametersLabel: l10n.backupSheetParameters,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final textTheme = theme.textTheme;
      final l10n = context.l10n;
      final sheet = state.sheet;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.backupPreviewTitle, style: textTheme.titleLarge),
              if (sheet != null) ...[
                const SizedBox(height: 2),
                Text(
                  l10n.backupPreviewSummary(sheet.accountCount, sheet.pages.length),
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 16),
              Flexible(
                child: OtpBackupPages(pages: sheet?.pages, failed: state.previewFailed),
              ),
              const SizedBox(height: 16),
              Text(
                state.printFailed ? l10n.printBackupFailed : l10n.backupPreviewWarning,
                style: textTheme.bodyMedium?.copyWith(
                  color: state.printFailed ? colorScheme.error : colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: sheet == null ? null : presenter.onPrintPressed,
                child: Text(l10n.backupPreviewPrint),
              ),
            ],
          ),
        ),
      );
    },
  );
}
