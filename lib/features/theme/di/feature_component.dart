import 'package:app_core/di/app_component.dart';
import 'package:app_core/features/theme/data/repository/theme_repository_impl.dart';
import 'package:app_core/features/theme/theme_builder/domain/repository/theme_builder_repository.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_presenter.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_state.dart';
import 'package:app_core/features/theme/theme_mode_switch/domain/repository/theme_mode_switch_repository.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_presenter.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_state.dart';
import 'package:app_core/features/theme/theme_picker/domain/repository/theme_picker_repository.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_presenter.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_state.dart';
//DO-NOT-REMOVE FEATURE_COMPONENT_IMPORTS

class ThemeFeatureComponent implements FeatureComponent {
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
    // ignore: unnecessary_statements
    appComponent
    //DO-NOT-REMOVE GENERAL_DEPS_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureRepositories({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements
    appComponent
      ..registerLazySingleton<ThemeRepositoryImpl>(() => ThemeRepositoryImpl(appComponent.get()))
      ..registerFactory<ThemeBuilderRepository>(appComponent.get<ThemeRepositoryImpl>)
      ..registerFactory<ThemePickerRepository>(appComponent.get<ThemeRepositoryImpl>)
      ..registerFactory<ThemeModeSwitchRepository>(appComponent.get<ThemeRepositoryImpl>)
    //DO-NOT-REMOVE REPOSITORIES_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureStores({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements
    appComponent
    //DO-NOT-REMOVE STORES_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureUseCases({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements
    appComponent
    //DO-NOT-REMOVE USE_CASES_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureMvp({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements
    appComponent
      ..registerFactoryParam<ThemeBuilderState, ThemeBuilderStateParams?, dynamic>(
        (params, _) => ThemeBuilderState.fromInitialParams(params),
      )
      ..registerFactoryParam<ThemeBuilderPresenter, ThemeBuilderStateParams?, dynamic>(
        (params, _) => ThemeBuilderPresenter(appComponent.get(param1: params), appComponent.get()),
      )
      ..registerFactoryParam<ThemePickerState, ThemePickerStateParams?, dynamic>(
        (params, _) => ThemePickerState.fromInitialParams(params),
      )
      ..registerFactoryParam<ThemePickerPresenter, ThemePickerStateParams?, dynamic>(
        (params, _) => ThemePickerPresenter(appComponent.get(param1: params), appComponent.get(), appComponent.get()),
      )
      ..registerFactoryParam<ThemeModeSwitchState, ThemeModeSwitchStateParams?, dynamic>(
        (params, _) => ThemeModeSwitchState.fromInitialParams(params),
      )
      ..registerFactoryParam<ThemeModeSwitchPresenter, ThemeModeSwitchStateParams?, dynamic>(
        (params, _) => ThemeModeSwitchPresenter(appComponent.get(param1: params), appComponent.get()),
      )
    //DO-NOT-REMOVE MVP_GET_IT_CONFIG
    ;
  }
}
