import 'package:app_core/di/app_component.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_presenter.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_state.dart';
//DO-NOT-REMOVE FEATURE_COMPONENT_IMPORTS

class SettingsFeatureComponent implements FeatureComponent {
  @override
  Future<void> configureDependencies({required AppComponent appComponent}) async {
    await _configureGeneralDependencies(appComponent: appComponent);
    await _configureMvp(appComponent: appComponent);
    await _configureRepositories(appComponent: appComponent);
    await _configureStores(appComponent: appComponent);
    await _configureUseCases(appComponent: appComponent);
  }

  //ignore: long-method
  Future<void> _configureGeneralDependencies({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements, avoid_single_cascade_in_expression_statements
    appComponent
    //DO-NOT-REMOVE GENERAL_DEPS_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureRepositories({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements, avoid_single_cascade_in_expression_statements
    appComponent
    //DO-NOT-REMOVE REPOSITORIES_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureStores({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements, avoid_single_cascade_in_expression_statements
    appComponent
    //DO-NOT-REMOVE STORES_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureUseCases({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements, avoid_single_cascade_in_expression_statements
    appComponent
    //DO-NOT-REMOVE USE_CASES_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureMvp({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements, avoid_single_cascade_in_expression_statements
    appComponent
      ..registerFactoryParam<SettingsThemePickerState, SettingsThemePickerStateParams?, dynamic>(
        (params, _) => SettingsThemePickerState.fromInitialParams(params),
      )
      ..registerFactoryParam<SettingsThemePickerPresenter, SettingsThemePickerStateParams?, dynamic>(
        (params, _) => SettingsThemePickerPresenter(appComponent.get(param1: params), appComponent.get()),
      )
    //DO-NOT-REMOVE MVP_GET_IT_CONFIG
    ;
  }
}
