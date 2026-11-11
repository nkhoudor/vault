import 'package:recase/recase.dart';

String featureMockDefinitionsTemplate = """
import 'package:mocktail/mocktail.dart';
//DO-NOT-REMOVE IMPORTS_MOCK_DEFINITIONS

// MVP

//DO-NOT-REMOVE MVP_MOCK_DEFINITION

// USE CASES
//DO-NOT-REMOVE USE_CASE_MOCK_DEFINITION

// REPOSITORIES
//DO-NOT-REMOVE REPOSITORIES_MOCK_DEFINITION

// STORES
//DO-NOT-REMOVE STORES_MOCK_DEFINITION

""";

String featureMocksTemplate(String feature) =>
    """
import 'package:mocktail/mocktail.dart';

import '${feature.snakeCase}_mock_definitions.dart';
//DO-NOT-REMOVE IMPORTS_MOCKS

class ${feature.pascalCase}Mocks {

  // MVP

  //DO-NOT-REMOVE MVP_MOCKS_STATIC_FIELD

  // USE CASES


  //DO-NOT-REMOVE USE_CASE_MOCKS_STATIC_FIELD

  // REPOSITORIES
  //DO-NOT-REMOVE REPOSITORIES_MOCKS_STATIC_FIELD

  // STORES

  //DO-NOT-REMOVE STORES_MOCKS_STATIC_FIELD


  static void init() {
    _initMocks();
    _initFallbacks();
  }

  static void _initMocks() {
    //DO-NOT-REMOVE FEATURES_MOCKS
    // MVP
    //DO-NOT-REMOVE MVP_INIT_MOCKS

    // USE CASES
    //DO-NOT-REMOVE USE_CASE_INIT_MOCKS

    // REPOSITORIES
    //DO-NOT-REMOVE REPOSITORIES_INIT_MOCKS

    // STORES
    //DO-NOT-REMOVE STORES_INIT_MOCKS

  }

  static void _initFallbacks() {
    //DO-NOT-REMOVE FEATURES_FALLBACKS
    // MVP
    //DO-NOT-REMOVE MVP_MOCK_FALLBACK_VALUE

    // USE CASES
    //DO-NOT-REMOVE USE_CASE_MOCK_FALLBACK_VALUE

    // REPOSITORIES
    //DO-NOT-REMOVE REPOSITORIES_MOCK_FALLBACK_VALUE

    // STORES
    //DO-NOT-REMOVE STORES_MOCK_FALLBACK_VALUE

  }
}
""";

String featureComponentTemplate({required String appPackage, required String feature}) =>
    """
import 'package:$appPackage/di/app_component.dart';
//DO-NOT-REMOVE FEATURE_COMPONENT_IMPORTS

class ${feature.pascalCase}FeatureComponent implements FeatureComponent {
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
    //DO-NOT-REMOVE MVP_GET_IT_CONFIG
        ;
  }
}
""";

String featurePageTestConfigTemplate = """
import 'dart:async';

import '../../../test_utils/test_utils.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) => preparePageTests(testMain);
""";
