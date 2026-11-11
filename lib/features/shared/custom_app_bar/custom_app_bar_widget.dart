import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_presenter.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatefulWidget
    with MaybeHasPresenter<CustomAppBarPresenter>
    implements PreferredSizeWidget {
  const CustomAppBarWidget({required this.title, this.presenter, this.showSettings = false, super.key});

  final String title;
  final bool showSettings;

  @override
  final CustomAppBarPresenter? presenter;

  @override
  State<CustomAppBarWidget> createState() => _CustomAppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget>
    with PresenterStateMixin<CustomAppBarState, CustomAppBarPresenter, CustomAppBarWidget> {
  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(widget.title),
    actions: widget.showSettings
        ? [IconButton(icon: const Icon(Icons.settings), onPressed: () => presenter.onSettingsTapped())]
        : null,
  );
}
