import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_presenter.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_state.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_widget.dart';
import 'package:app_core/utils/selectable.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../helpers/golden_test_helpers.dart';

void main() {
  goldenTest(
    'theme_picker',
    builder: () {
      final mockRepo = MockThemePickerRepository();
      final themes = [
        const Selectable.selected(AppTheme.cozy),
        const Selectable.deselected(AppTheme.nord),
        const Selectable.deselected(AppTheme.dracula),
      ];
      when(() => mockRepo.getThemesStream()).thenAnswer((_) => Stream.value(themes));
      return ThemePickerWidget(
        presenter: ThemePickerPresenter(ThemePickerState(themes: themes), MockThemePickerNavigator(), mockRepo),
      );
    },
  );
}
