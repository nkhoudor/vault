import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_presenter.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_state.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_widget.dart';

import '../../../mocks.dart';
import '../../helpers/golden_test_helpers.dart';

void main() {
  goldenTest(
    'custom_app_bar_title_only',
    builder: () => CustomAppBarWidget(
      title: 'Title',
      showSettings: false,
      presenter: CustomAppBarPresenter(
        CustomAppBarState.empty(),
        MockCustomAppBarNavigator(),
        MockCustomAppBarRepository(),
      ),
    ),
  );

  goldenTest(
    'custom_app_bar_with_settings',
    builder: () => CustomAppBarWidget(
      title: 'Home',
      showSettings: true,
      presenter: CustomAppBarPresenter(
        CustomAppBarState.empty(),
        MockCustomAppBarNavigator(),
        MockCustomAppBarRepository(),
      ),
    ),
  );
}
