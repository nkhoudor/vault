import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_list/otp_list_presenter.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_account_grid.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_delete_dialog.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_dial.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_search_field.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class OtpListWidget extends StatefulWidget with MaybeHasPresenter<OtpListPresenter> {
  const OtpListWidget({this.presenter, this.trailing, super.key});

  @override
  final OtpListPresenter? presenter;

  /// Shown at the bottom, after the search field.
  final Widget? trailing;

  @override
  State<OtpListWidget> createState() => _OtpListWidgetState();
}

class _OtpListWidgetState extends State<OtpListWidget>
    with PresenterStateMixin<OtpListState, OtpListPresenter, OtpListWidget> {
  Future<void> _onCodeTapped(OtpDisplayable otp) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    await presenter.onCodeTapped(otp);
    if (mounted) {
      messenger.clearSnackBars();
      messenger.showSnackBar(SnackBar(content: Text(l10n.codeCopiedToClipboard), duration: const Duration(seconds: 1)));
    }
  }

  Future<void> _onAccountLongPressed(OtpDisplayable otp) async {
    final confirmed = await OtpDeleteDialog.show(context, name: otp.label);
    if (confirmed) {
      await presenter.onDeleteConfirmed(otp);
    }
  }

  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) {
      final selected = state.selectedEntry;

      return SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: selected == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.isSearching ? context.l10n.noMatchingAccounts : '',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [
                        OtpDial(otp: selected, onTap: () => _onCodeTapped(selected)),
                        const SizedBox(height: 20),
                        OtpAccountGrid(
                          entries: state.visibleEntries,
                          selectedId: selected.id,
                          onSelected: presenter.onAccountSelected,
                          onLongPressed: _onAccountLongPressed,
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: state.otpList.isEmpty
                        ? const SizedBox.shrink()
                        : OtpSearchField(query: state.searchQuery, onChanged: presenter.onSearchChanged),
                  ),
                  if (widget.trailing case final trailing?) ...[const SizedBox(width: 12), trailing],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
