import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_presenter.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class OtpManualEntryWidget extends StatefulWidget with MaybeHasPresenter<OtpManualEntryPresenter> {
  const OtpManualEntryWidget({this.presenter, super.key});

  @override
  final OtpManualEntryPresenter? presenter;

  @override
  State<OtpManualEntryWidget> createState() => _OtpManualEntryWidgetState();
}

class _OtpManualEntryWidgetState extends State<OtpManualEntryWidget>
    with PresenterStateMixin<OtpManualEntryState, OtpManualEntryPresenter, OtpManualEntryWidget> {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) {
      final l10n = context.l10n;
      final theme = Theme.of(context);

      return ListView(
        padding: const EdgeInsets.all(16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          TextField(
            onChanged: presenter.onIssuerChanged,
            enabled: !state.isSaving,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.manualEntryIssuerLabel,
              hintText: l10n.manualEntryIssuerHint,
              errorText: state.showIssuerError ? l10n.manualEntryIssuerRequired : null,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: presenter.onAccountChanged,
            enabled: !state.isSaving,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l10n.manualEntryAccountLabel,
              hintText: l10n.manualEntryAccountHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: presenter.onSecretKeyChanged,
            onSubmitted: (_) => presenter.onSavePressed(),
            enabled: !state.isSaving,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l10n.manualEntrySecretKeyLabel,
              helperText: l10n.manualEntrySecretKeyHelper,
              helperMaxLines: 2,
              errorText: state.showSecretKeyError ? l10n.manualEntrySecretKeyInvalid : null,
              errorMaxLines: 2,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          if (state.saveFailed) ...[
            Text(
              l10n.saveFailed,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
          FilledButton(onPressed: state.isSaving ? null : presenter.onSavePressed, child: Text(l10n.manualEntrySave)),
        ],
      );
    },
  );
}
