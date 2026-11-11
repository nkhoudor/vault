import 'package:app_core/di/app_component.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_presenter.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_state.dart';
import 'package:app_core/features/shared/custom_app_bar/domain/repository/custom_app_bar_repository.dart';
import 'package:app_core/features/shared/data/repository/custom_app_bar_repository_impl.dart';
//DO-NOT-REMOVE FEATURE_COMPONENT_IMPORTS

class SharedFeatureComponent implements FeatureComponent {
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
    appComponent..registerFactory<CustomAppBarRepository>(CustomAppBarRepositoryImpl.new)
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
      ..registerFactoryParam<CustomAppBarState, CustomAppBarStateParams?, dynamic>(
        (params, _) => CustomAppBarState.fromInitialParams(params),
      )
      ..registerFactoryParam<CustomAppBarPresenter, CustomAppBarStateParams?, dynamic>(
        (params, _) => CustomAppBarPresenter(appComponent.get(param1: params), appComponent.get(), appComponent.get()),
      )
    //DO-NOT-REMOVE MVP_GET_IT_CONFIG
    ;
  }
}
