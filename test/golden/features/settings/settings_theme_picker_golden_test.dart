import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_presenter.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_state.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_widget.dart';

import '../../../mocks.dart';
import '../../helpers/golden_test_helpers.dart';

void main() {
  goldenTest(
    'settings_theme_picker',
    builder: () => SettingsThemePickerWidget(
      presenter: SettingsThemePickerPresenter(SettingsThemePickerState.empty(), MockSettingsThemePickerNavigator()),
    ),
  );
}
