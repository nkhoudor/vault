import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';

abstract class ThemeModeSwitchRepository {
  Stream<AppThemeMode> getThemeModeStream();
  Future<void> setThemeMode(AppThemeMode themeMode);
}
