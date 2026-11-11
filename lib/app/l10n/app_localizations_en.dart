// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vault';

  @override
  String get error => 'Error';

  @override
  String routeNotFound(String path) {
    return 'Route not found: $path';
  }

  @override
  String get goHome => 'Go Home';

  @override
  String get settings => 'Settings';

  @override
  String get themePicker => 'Theme Picker';

  @override
  String get otpScanner => 'Scan QR code';

  @override
  String get otpManualEntry => 'Enter setup key';
}
