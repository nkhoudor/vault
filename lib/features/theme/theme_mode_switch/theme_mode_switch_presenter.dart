import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/theme_mode_switch/domain/repository/theme_mode_switch_repository.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeSwitchPresenter extends Cubit<ThemeModeSwitchState> with SubscriptionsMixin {
  ThemeModeSwitchPresenter(super.model, this._repository) {
    listenTo(
      stream: _repository.getThemeModeStream(),
      subscriptionId: _themeModeStreamSubscription,
      onChange: (themeMode) => tryEmit(state.copyWith(themeMode: themeMode)),
    );
  }

  //ignore: unused_field
  final ThemeModeSwitchRepository _repository;

  static const _themeModeStreamSubscription = 'themeModeStreamSubscription';

  Future<void> onThemeModeSelected(AppThemeMode themeMode) => _repository.setThemeMode(themeMode);
}
