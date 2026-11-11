import 'package:app_core/app/data/repository/flutter_secure_storage_impl.dart';
import 'package:app_core/app/data/repository/flutter_system_clipboard.dart';
import 'package:app_core/app/data/repository/rx_shared_preferences_storage.dart';
import 'package:app_core/app/presentation/app_navigator.dart';
import 'package:app_core/app/presentation/navigation_service.dart';
import 'package:app_core/app/presentation/routes/router.dart';
import 'package:app_core/core/clipboard/system_clipboard.dart';
import 'package:app_core/core/storage/reactive_storage.dart';
import 'package:app_core/core/storage/secure_storage.dart';
import 'package:app_core/di/app_component.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_navigator.dart';
import 'package:app_core/features/otp/otp_list/otp_list_navigator.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_navigator.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_navigator.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_navigator.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_navigator.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_navigator.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_navigator.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_navigator.dart';
import 'package:go_router/go_router.dart';
//DO-NOT-REMOVE FEATURE_COMPONENT_IMPORTS

class AppFeatureComponent implements FeatureComponent {
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
    final router = createRouter();
    appComponent
      ..registerSingleton<GoRouter>(router)
      ..registerSingleton<NavigationService>(NavigationService(router))
      // Every feature's navigator interface is implemented by the one AppNavigator.
      ..registerLazySingleton<AppNavigator>(() => AppNavigator(appComponent.get()))
      ..registerFactory<CustomAppBarNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<SettingsThemePickerNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<OtpAddButtonNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<OtpScannerNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<OtpManualEntryNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<OtpListNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<ThemeBuilderNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<ThemeModeSwitchNavigator>(appComponent.get<AppNavigator>)
      ..registerFactory<ThemePickerNavigator>(appComponent.get<AppNavigator>)
    //DO-NOT-REMOVE GENERAL_DEPS_GET_IT_CONFIG
    ;
  }

  //ignore: long-method
  Future<void> _configureRepositories({required AppComponent appComponent}) async {
    // ignore: unnecessary_statements
    appComponent
      ..registerLazySingleton<ReactiveStorage>(
        RxSharedPreferencesStorage.new,
        dispose: (instance) => (instance as RxSharedPreferencesStorage).dispose(),
      )
      ..registerLazySingleton<SecureStorage>(FlutterSecureStorageImpl.new)
      ..registerLazySingleton<SystemClipboard>(FlutterSystemClipboard.new)
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
    //DO-NOT-REMOVE MVP_GET_IT_CONFIG
    ;
  }
}
