import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/utils/selectable.dart';

abstract class ThemePickerRepository {
  Stream<Iterable<Selectable<AppTheme>>> getThemesStream();
  Future<void> selectTheme(AppTheme appTheme);
}
