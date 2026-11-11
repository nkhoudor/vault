import 'package:app_core/app/data/repository/flutter_system_clipboard.dart';
import 'package:app_core/app/presentation/app_navigator.dart';
import 'package:app_core/core/clipboard/system_clipboard.dart';
import 'package:app_core/di/app_component.dart';
import 'package:app_core/features/otp/data/repository/otp_repository_impl.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_navigator.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_presenter.dart';
import 'package:app_core/features/otp/otp_list/domain/repository/otp_list_repository.dart';
import 'package:app_core/features/otp/otp_list/otp_list_navigator.dart';
import 'package:app_core/features/otp/otp_manual_entry/domain/repository/otp_manual_entry_repository.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_navigator.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_presenter.dart';
import 'package:app_core/features/otp/otp_scanner/domain/repository/otp_scanner_repository.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_navigator.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_presenter.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_presenter.dart';
import 'package:app_core/features/shared/custom_app_bar/domain/repository/custom_app_bar_repository.dart';
import 'package:app_core/features/shared/data/repository/custom_app_bar_repository_impl.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_navigator.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_navigator.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_navigator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Checks the wiring a running app gets: every contract a feature declares has a real implementation.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DI.configureDependencies();
  });

  test('the OTP navigators are implemented by the app navigator', () {
    expect(DI.get<OtpAddButtonNavigator>(), isA<AppNavigator>());
    expect(DI.get<OtpScannerNavigator>(), isA<AppNavigator>());
    expect(DI.get<OtpManualEntryNavigator>(), isA<AppNavigator>());
  });

  test('the navigators without actions are implemented by the app navigator too', () {
    expect(DI.get<OtpListNavigator>(), isA<AppNavigator>());
    expect(DI.get<ThemeBuilderNavigator>(), isA<AppNavigator>());
    expect(DI.get<ThemeModeSwitchNavigator>(), isA<AppNavigator>());
    expect(DI.get<ThemePickerNavigator>(), isA<AppNavigator>());
  });

  test('the app bar gets a real repository and its presenter can be created', () {
    expect(DI.get<CustomAppBarRepository>(), isA<CustomAppBarRepositoryImpl>());
    expect(DI.get<CustomAppBarPresenter>(), isNotNull);
  });

  test('the clipboard is the device clipboard', () {
    expect(DI.get<SystemClipboard>(), isA<FlutterSystemClipboard>());
  });

  test('the OTP repositories are implemented by the secret repository', () {
    expect(DI.get<OtpListRepository>(), isA<OtpRepositoryImpl>());
    expect(DI.get<OtpScannerRepository>(), isA<OtpRepositoryImpl>());
    expect(DI.get<OtpManualEntryRepository>(), isA<OtpRepositoryImpl>());
  });

  test('the OTP repositories are one shared instance', () {
    expect(DI.get<OtpScannerRepository>(), same(DI.get<OtpListRepository>()));
    expect(DI.get<OtpManualEntryRepository>(), same(DI.get<OtpListRepository>()));
  });

  test('the OTP presenters can be created', () {
    expect(DI.get<OtpAddButtonPresenter>(), isNotNull);
    expect(DI.get<OtpScannerPresenter>(), isNotNull);
    expect(DI.get<OtpManualEntryPresenter>(), isNotNull);
  });
}
