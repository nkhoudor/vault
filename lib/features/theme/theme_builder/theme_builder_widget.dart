import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_presenter.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class ThemeBuilderWidget extends StatefulWidget with MaybeHasPresenter<ThemeBuilderPresenter> {
  const ThemeBuilderWidget({required this.builder, this.presenter, super.key});

  final Widget Function(AppTheme appTheme, AppThemeMode themeMode) builder;

  @override
  final ThemeBuilderPresenter? presenter;

  @override
  State<ThemeBuilderWidget> createState() => _ThemeBuilderWidgetState();
}

class _ThemeBuilderWidgetState extends State<ThemeBuilderWidget>
    with PresenterStateMixin<ThemeBuilderState, ThemeBuilderPresenter, ThemeBuilderWidget> {
  @override
  Widget build(BuildContext context) =>
      stateObserver(builder: (_, state) => widget.builder(state.appTheme, state.themeMode));
}
