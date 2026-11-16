import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_list/otp_list_presenter.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_account_grid.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_delete_dialog.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_dial.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_list_footer.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_search_field.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_setup_steps.dart';
import 'package:app_core/utils/motion.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class OtpListWidget extends StatefulWidget with MaybeHasPresenter<OtpListPresenter> {
  const OtpListWidget({this.presenter, this.trailingBuilder, super.key});

  @override
  final OtpListPresenter? presenter;

  /// Builds what is shown at the bottom, after the search field.
  final OtpListTrailingBuilder? trailingBuilder;

  @override
  State<OtpListWidget> createState() => _OtpListWidgetState();
}

class _OtpListWidgetState extends State<OtpListWidget>
    with PresenterStateMixin<OtpListState, OtpListPresenter, OtpListWidget> {
  static const _switchDuration = Duration(milliseconds: 400);
  static const _setupKey = ValueKey('setup');
  static const _accountsKey = ValueKey('accounts');

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

  /// The setup steps fade and rise away in the first half; the accounts fade and grow in from a quarter on.
  /// Going back to the steps plays the same in reverse.
  Widget _switchTransition(Widget child, Animation<double> animation) {
    if (child.key == _setupKey) {
      final progress = animation.drive(CurveTween(curve: const Interval(0.5, 1, curve: Curves.easeInOutCubic)));
      return SlideTransition(
        position: progress.drive(Tween(begin: const Offset(0, -0.02), end: Offset.zero)),
        child: FadeTransition(opacity: progress, child: child),
      );
    }
    final progress = animation.drive(CurveTween(curve: const Interval(0.25, 1, curve: Curves.easeInOutCubic)));
    return ScaleTransition(
      scale: progress.drive(Tween(begin: 0.94, end: 1)),
      child: FadeTransition(opacity: progress, child: child),
    );
  }

  Widget _accounts(OtpListState state) {
    final selected = state.selectedEntry;
    if (selected == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            context.l10n.noMatchingAccounts,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
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
    );
  }

  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) {
      if (state.isLoading) return const SizedBox.shrink();

      return SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: context.motionDuration(_switchDuration),
                transitionBuilder: _switchTransition,
                child: state.hasNoAccounts
                    ? const OtpSetupSteps(key: _setupKey)
                    : KeyedSubtree(key: _accountsKey, child: _accounts(state)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OtpListFooter(
                showSearch: !state.hasNoAccounts,
                search: OtpSearchField(query: state.searchQuery, onChanged: presenter.onSearchChanged),
                trailingBuilder: widget.trailingBuilder,
              ),
            ),
          ],
        ),
      );
    },
  );
}
