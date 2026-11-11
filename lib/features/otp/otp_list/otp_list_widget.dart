import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_list/otp_list_presenter.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_delete_dialog.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_search_field.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_slidable_list_item.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OtpListWidget extends StatefulWidget with MaybeHasPresenter<OtpListPresenter> {
  const OtpListWidget({this.presenter, super.key});

  @override
  final OtpListPresenter? presenter;

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
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.codeCopiedToClipboard),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _onDeletePressed(OtpDisplayable otp) async {
    final confirmed = await OtpDeleteDialog.show(context, name: otp.label);
    if (confirmed) {
      await presenter.onDeleteConfirmed(otp);
    }
  }

  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) {
      final entries = state.visibleEntries;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.otpList.isNotEmpty) OtpSearchField(query: state.searchQuery, onChanged: presenter.onSearchChanged),
          Expanded(
            child: entries.isEmpty && state.isSearching
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.l10n.noMatchingAccounts,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SlidableAutoCloseBehavior(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: entries.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, index) {
                        final otp = entries[index];
                        return OtpSlidableListItem(
                          key: ValueKey(otp.id),
                          otp: otp,
                          onTap: () => _onCodeTapped(otp),
                          onDeletePressed: () => _onDeletePressed(otp),
                        );
                      },
                    ),
                  ),
          ),
        ],
      );
    },
  );
}
