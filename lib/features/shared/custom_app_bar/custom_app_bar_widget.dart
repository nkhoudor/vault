import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_presenter.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatefulWidget
    with MaybeHasPresenter<CustomAppBarPresenter>
    implements PreferredSizeWidget {
  const CustomAppBarWidget({this.title, this.presenter, this.showSettings = false, super.key});

  final String? title;
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
  Widget build(BuildContext context) => IconButtonTheme(
    data: IconButtonThemeData(
      style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh),
    ),
    child: AppBar(
      title: widget.title == null ? null : Text(widget.title!),
      actionsPadding: const EdgeInsets.only(right: 12),
      actions: widget.showSettings
          ? [IconButton(icon: const Icon(Icons.tune), onPressed: presenter.onSettingsTapped)]
          : null,
    ),
  );
}
