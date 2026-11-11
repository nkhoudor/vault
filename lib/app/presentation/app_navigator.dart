import 'package:app_core/app/presentation/navigation_service.dart';
import 'package:app_core/app/presentation/routes/app_routes.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_navigator.dart';
import 'package:app_core/features/otp/otp_list/otp_list_navigator.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_navigator.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_navigator.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_navigator.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_navigator.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_navigator.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_navigator.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_navigator.dart';

class AppNavigator
    implements
        CustomAppBarNavigator,
        SettingsThemePickerNavigator,
        OtpAddButtonNavigator,
        OtpListNavigator,
        OtpScannerNavigator,
        OtpManualEntryNavigator,
        ThemeBuilderNavigator,
        ThemeModeSwitchNavigator,
        ThemePickerNavigator {
  AppNavigator(this._navigationService);

  final NavigationService _navigationService;

  @override
  Future<void> navigateToSettings() async {
    _navigationService.goRoute(const AppRoute.settings());
  }

  @override
  Future<void> navigateToThemePicker() async {
    _navigationService.goRoute(const AppRoute.themePicker());
  }

  @override
  Future<void> navigateToOtpScanner() async {
    _navigationService.goRoute(const AppRoute.otpScanner());
  }

  @override
  Future<void> navigateToOtpManualEntry() async {
    _navigationService.goRoute(const AppRoute.otpManualEntry());
  }

  @override
  Future<void> navigateBack() async {
    _navigationService.goBack();
  }
}
