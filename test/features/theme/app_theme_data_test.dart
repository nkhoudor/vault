import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/themes/app_theme_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final mode in AppThemeMode.values) {
    test('$mode draws the Flutter theme mode of the same name', () {
      expect(mode.flutterThemeMode.name, mode.name);
    });
  }
}
