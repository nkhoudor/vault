import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/theme_picker/domain/repository/theme_picker_repository.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_navigator.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePickerPresenter extends Cubit<ThemePickerState> with SubscriptionsMixin {
  ThemePickerPresenter(super.model, this._navigator, this._repository) {
    listenTo(
      stream: _repository.getThemesStream(),
      subscriptionId: _themesStreamSubscription,
      onChange: (themes) => tryEmit(state.copyWith(themes: themes)),
    );
  }

  //ignore: unused_field
  final ThemePickerNavigator _navigator;
  //ignore: unused_field
  final ThemePickerRepository _repository;

  static const _themesStreamSubscription = 'themesStreamSubscription';

  Future<void> onThemeSelected(AppTheme appTheme) => _repository.selectTheme(appTheme);
}
