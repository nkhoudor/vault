import 'package:app_core/di/app_component.dart';
import 'package:app_core/features/otp/data/repository/otp_repository_impl.dart';
import 'package:app_core/features/otp/domain/use_case/parse_otp_auth_uri_use_case.dart';
import 'package:app_core/features/otp/domain/use_case/watch_otp_list_use_case.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_presenter.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_state.dart';
import 'package:app_core/features/otp/otp_list/domain/repository/otp_list_repository.dart';
import 'package:app_core/features/otp/otp_list/otp_list_presenter.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/features/otp/otp_manual_entry/domain/repository/otp_manual_entry_repository.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_presenter.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_state.dart';
import 'package:app_core/features/otp/otp_scanner/domain/repository/otp_scanner_repository.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_presenter.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
//DO-NOT-REMOVE FEATURE_COMPONENT_IMPORTS

class OtpFeatureComponent implements FeatureComponent {
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
      ..registerLazySingleton<OtpRepositoryImpl>(() => OtpRepositoryImpl(appComponent.get(), appComponent.get()))
      ..registerFactory<OtpListRepository>(appComponent.get<OtpRepositoryImpl>)
      ..registerFactory<OtpScannerRepository>(appComponent.get<OtpRepositoryImpl>)
      ..registerFactory<OtpManualEntryRepository>(appComponent.get<OtpRepositoryImpl>)
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
      ..registerFactory<ParseOtpAuthUriUseCase>(ParseOtpAuthUriUseCase.new)
      ..registerFactory<WatchOtpListUseCase>(() => WatchOtpListUseCase(appComponent.get()))
    //DO-NOT-REMOVE USE_CASES_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureMvp({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements, avoid_single_cascade_in_expression_statements
    appComponent
      ..registerFactoryParam<OtpListState, OtpListStateParams?, dynamic>(
        (params, _) => OtpListState.fromInitialParams(params),
      )
      ..registerFactoryParam<OtpListPresenter, OtpListStateParams?, dynamic>(
        (params, _) => OtpListPresenter(
          appComponent.get(param1: params),
          appComponent.get(),
          appComponent.get(),
          appComponent.get(),
        ),
      )
      ..registerFactoryParam<OtpAddButtonState, OtpAddButtonStateParams?, dynamic>(
        (params, _) => OtpAddButtonState.fromInitialParams(params),
      )
      ..registerFactoryParam<OtpAddButtonPresenter, OtpAddButtonStateParams?, dynamic>(
        (params, _) => OtpAddButtonPresenter(appComponent.get(param1: params), appComponent.get()),
      )
      ..registerFactoryParam<OtpScannerState, OtpScannerStateParams?, dynamic>(
        (params, _) => OtpScannerState.fromInitialParams(params),
      )
      ..registerFactoryParam<OtpScannerPresenter, OtpScannerStateParams?, dynamic>(
        (params, _) => OtpScannerPresenter(
          appComponent.get(param1: params),
          appComponent.get(),
          appComponent.get(),
          appComponent.get(),
        ),
      )
      ..registerFactoryParam<OtpManualEntryState, OtpManualEntryStateParams?, dynamic>(
        (params, _) => OtpManualEntryState.fromInitialParams(params),
      )
      ..registerFactoryParam<OtpManualEntryPresenter, OtpManualEntryStateParams?, dynamic>(
        (params, _) =>
            OtpManualEntryPresenter(appComponent.get(param1: params), appComponent.get(), appComponent.get()),
      )
    //DO-NOT-REMOVE MVP_GET_IT_CONFIG
    ;
  }
}
