import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';

abstract class ThemeBuilderRepository {
  Stream<AppTheme> getAppThemeStream();
  Stream<AppThemeMode> getThemeModeStream();
}
