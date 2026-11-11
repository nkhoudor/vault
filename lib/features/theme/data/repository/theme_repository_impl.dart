import 'dart:async';

import 'package:app_core/core/storage/reactive_storage.dart';
import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/theme_builder/domain/repository/theme_builder_repository.dart';
import 'package:app_core/features/theme/theme_mode_switch/domain/repository/theme_mode_switch_repository.dart';
import 'package:app_core/features/theme/theme_picker/domain/repository/theme_picker_repository.dart';
import 'package:app_core/utils/selectable.dart';
import 'package:rxdart/rxdart.dart';

class ThemeRepositoryImpl implements ThemeBuilderRepository, ThemePickerRepository, ThemeModeSwitchRepository {
  ThemeRepositoryImpl(this._storage);

  static const _themeKey = 'selected_theme_name';
  static const _themeModeKey = 'theme_mode';

  final ReactiveStorage _storage;

  late final _defaultThemeMode = AppThemeMode.system;

  @override
  Stream<AppTheme> getAppThemeStream() {
    return _getThemeNameStream().map(
      (selectedThemeName) => AppTheme.values.firstWhere((theme) => theme.name == selectedThemeName),
    );
  }

  @override
  Stream<Iterable<Selectable<AppTheme>>> getThemesStream() {
    return _getThemeNameStream().map((selectedThemeName) {
      return AppTheme.values.map((theme) => Selectable.toSelectable(theme, selectedThemeName == theme.name));
    });
  }

  @override
  Future<void> selectTheme(AppTheme appTheme) async {
    await _storage.setString(_themeKey, appTheme.name);
  }

  @override
  Stream<AppThemeMode> getThemeModeStream() {
    return _storage
        .getStringStream(_themeModeKey)
        .mapNotNull((name) => AppThemeMode.values.byName(name ?? _defaultThemeMode.name));
  }

  @override
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await _storage.setString(_themeModeKey, themeMode.name);
  }

  Stream<String> _getThemeNameStream() {
    return _storage.getStringStream(_themeKey).mapNotNull((name) => name ?? AppTheme.defaultTheme.name);
  }
}
