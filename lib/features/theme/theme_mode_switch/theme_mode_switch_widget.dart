import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/l10n/theme_localizations.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_presenter.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class ThemeModeSwitchWidget extends StatefulWidget with MaybeHasPresenter<ThemeModeSwitchPresenter> {
  const ThemeModeSwitchWidget({this.presenter, super.key});

  @override
  final ThemeModeSwitchPresenter? presenter;

  @override
  State<ThemeModeSwitchWidget> createState() => _ThemeModeSwitchWidgetState();
}

class _ThemeModeSwitchWidgetState extends State<ThemeModeSwitchWidget>
    with PresenterStateMixin<ThemeModeSwitchState, ThemeModeSwitchPresenter, ThemeModeSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.themeMode, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 12),
        stateObserver(
          builder: (context, state) => SegmentedButton<AppThemeMode>(
            segments: [
              ButtonSegment<AppThemeMode>(value: AppThemeMode.system, label: Text(l10n.system)),
              ButtonSegment<AppThemeMode>(value: AppThemeMode.light, label: Text(l10n.light)),
              ButtonSegment<AppThemeMode>(value: AppThemeMode.dark, label: Text(l10n.dark)),
            ],
            selected: {state.themeMode},
            onSelectionChanged: (newSelection) => presenter.onThemeModeSelected(newSelection.first),
            showSelectedIcon: false,
          ),
        ),
      ],
    );
  }
}
