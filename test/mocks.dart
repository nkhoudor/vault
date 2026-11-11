import 'package:app_core/features/otp/domain/use_case/watch_otp_list_use_case.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_navigator.dart';
import 'package:app_core/features/otp/otp_list/domain/repository/otp_list_repository.dart';
import 'package:app_core/features/otp/otp_list/otp_list_navigator.dart';
import 'package:app_core/features/otp/otp_manual_entry/domain/repository/otp_manual_entry_repository.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_navigator.dart';
import 'package:app_core/features/otp/otp_scanner/domain/repository/otp_scanner_repository.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_navigator.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_navigator.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_navigator.dart';
import 'package:app_core/features/shared/custom_app_bar/domain/repository/custom_app_bar_repository.dart';
import 'package:app_core/features/theme/theme_mode_switch/domain/repository/theme_mode_switch_repository.dart';
import 'package:app_core/features/theme/theme_picker/domain/repository/theme_picker_repository.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_navigator.dart';
import 'package:mocktail/mocktail.dart';

class MockOtpAddButtonNavigator extends Mock implements OtpAddButtonNavigator {}

class MockOtpListNavigator extends Mock implements OtpListNavigator {}

class MockOtpListRepository extends Mock implements OtpListRepository {}

class MockWatchOtpListUseCase extends Mock implements WatchOtpListUseCase {}

class MockOtpManualEntryNavigator extends Mock implements OtpManualEntryNavigator {}

class MockOtpManualEntryRepository extends Mock implements OtpManualEntryRepository {}

class MockOtpScannerNavigator extends Mock implements OtpScannerNavigator {}

class MockOtpScannerRepository extends Mock implements OtpScannerRepository {}

class MockSettingsThemePickerNavigator extends Mock implements SettingsThemePickerNavigator {}

class MockCustomAppBarNavigator extends Mock implements CustomAppBarNavigator {}

class MockCustomAppBarRepository extends Mock implements CustomAppBarRepository {}

class MockThemeModeSwitchRepository extends Mock implements ThemeModeSwitchRepository {}

class MockThemePickerNavigator extends Mock implements ThemePickerNavigator {}

class MockThemePickerRepository extends Mock implements ThemePickerRepository {}
