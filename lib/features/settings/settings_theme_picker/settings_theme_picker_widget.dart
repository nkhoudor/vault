import 'package:app_core/features/settings/l10n/settings_localizations.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_presenter.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter/material.dart';

class SettingsThemePickerWidget extends StatefulWidget with MaybeHasPresenter<SettingsThemePickerPresenter> {
  const SettingsThemePickerWidget({this.presenter, super.key});

  @override
  final SettingsThemePickerPresenter? presenter;

  @override
  State<SettingsThemePickerWidget> createState() => _SettingsThemePickerWidgetState();
}

class _SettingsThemePickerWidgetState extends State<SettingsThemePickerWidget>
    with PresenterStateMixin<SettingsThemePickerState, SettingsThemePickerPresenter, SettingsThemePickerWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurface;
    final l10n = context.l10n;
    return ListTile(
      leading: Icon(Icons.palette, color: iconColor),
      title: Text(l10n.themePicker),
      subtitle: Text(l10n.themePickerSubtitle),
      trailing: Icon(Icons.chevron_right, color: iconColor),
      contentPadding: EdgeInsets.zero,
      onTap: () => presenter.onThemePickerPressed(),
    );
  }
}
