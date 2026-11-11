import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_navigator.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsThemePickerPresenter extends Cubit<SettingsThemePickerState> {
  SettingsThemePickerPresenter(super.model, this._navigator);

  //ignore: unused_field
  final SettingsThemePickerNavigator _navigator;

  Future<void> onThemePickerPressed() => _navigator.navigateToThemePicker();
}
