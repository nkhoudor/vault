import 'package:app_core/features/theme/theme_builder/domain/repository/theme_builder_repository.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBuilderPresenter extends Cubit<ThemeBuilderState> with SubscriptionsMixin {
  ThemeBuilderPresenter(super.model, this._repository) {
    listenTo(
      stream: _repository.getAppThemeStream(),
      subscriptionId: _appThemeStreamSubscription,
      onChange: (appTheme) => tryEmit(state.copyWith(appTheme: appTheme)),
    );
    listenTo(
      stream: _repository.getThemeModeStream(),
      subscriptionId: _themeModeStreamSubscription,
      onChange: (themeMode) => tryEmit(state.copyWith(themeMode: themeMode)),
    );
  }

  //ignore: unused_field
  final ThemeBuilderRepository _repository;

  static const _appThemeStreamSubscription = 'appThemeStreamSubscription';
  static const _themeModeStreamSubscription = 'themeModeStreamSubscription';
}
