import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_presenter.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_state.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../helpers/golden_test_helpers.dart';

void main() {
  goldenTest(
    'theme_mode_switch',
    builder: () {
      final mockRepo = MockThemeModeSwitchRepository();
      when(() => mockRepo.getThemeModeStream()).thenAnswer((_) => Stream.value(AppThemeMode.light));
      return ThemeModeSwitchWidget(
        presenter: ThemeModeSwitchPresenter(const ThemeModeSwitchState(themeMode: AppThemeMode.light), mockRepo),
      );
    },
  );
}
