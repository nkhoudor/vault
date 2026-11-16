// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'otp_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class OtpLocalizationsEn extends OtpLocalizations {
  OtpLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get addAccount => 'Add account';

  @override
  String get addOptionEnterManually => 'Enter setup key';

  @override
  String get addOptionEnterManuallyHint => 'Type the key shown next to the QR code';

  @override
  String get addOptionScanQrCode => 'Scan QR code';

  @override
  String get addOptionScanQrCodeHint => 'Use the camera on the code a service shows';

  @override
  String get backup => 'Backup';

  @override
  String get backupPreviewFailed => 'The sheet could not be prepared. Try again.';

  @override
  String get backupPreviewPrint => 'Print or save as PDF';

  @override
  String backupPreviewSummary(int count, int pageCount) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count accounts', one: '1 account');
    String _temp1 = intl.Intl.pluralLogic(pageCount, locale: localeName, other: '$pageCount pages', one: '1 page');
    return '$_temp0 · $_temp1';
  }

  @override
  String get backupPreviewTitle => 'Backup sheet';

  @override
  String get backupPreviewWarning => 'The sheet shows every setup key. Anyone who has it can generate your codes.';

  @override
  String get backupSheetFooter =>
      'Scan with any app, or type the key. Time-based, SHA1, 6 digits, 30 s unless a card says otherwise.';

  @override
  String backupSheetPage(int page, int pageCount) {
    return 'Page $page of $pageCount';
  }

  @override
  String backupSheetParameters(String algorithm, int digits, int period) {
    return '$algorithm · $digits digits · $period s';
  }

  @override
  String backupSheetSummary(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count accounts', one: '1 account');
    return '$_temp0 · exported $date';
  }

  @override
  String get backupSheetTitle => 'Authenticator backup';

  @override
  String get backupSheetWarning => 'Keep this page private. Anyone who has it can generate your codes.';

  @override
  String get cancel => 'Cancel';

  @override
  String get codeCopiedToClipboard => 'Code copied to clipboard';

  @override
  String get delete => 'Delete';

  @override
  String deleteOtpMessage(String name) {
    return 'The code for $name will be removed from this device. Make sure you can still sign in to that account without it.';
  }

  @override
  String get deleteOtpTitle => 'Delete this code?';

  @override
  String get manualEntryAccountHint => 'name@example.com';

  @override
  String get manualEntryAccountLabel => 'Account (optional)';

  @override
  String get manualEntryIssuerHint => 'GitHub';

  @override
  String get manualEntryIssuerLabel => 'Service';

  @override
  String get manualEntryIssuerRequired => 'Enter the name of the service.';

  @override
  String get manualEntrySave => 'Add account';

  @override
  String get manualEntrySecretKeyHelper => 'The key the service shows next to its QR code.';

  @override
  String get manualEntrySecretKeyInvalid =>
      'This is not a valid setup key. It can only contain the letters A–Z and the digits 2–7.';

  @override
  String get manualEntrySecretKeyLabel => 'Setup key';

  @override
  String get noMatchingAccounts => 'No matching accounts';

  @override
  String get printBackupFailed => 'The sheet could not be printed. Try again.';

  @override
  String get printBackupSheet => 'Print backup sheet';

  @override
  String get printBackupSheetNoAccounts => 'Add an account to print a sheet';

  @override
  String get printBackupSheetSubtitle => 'All accounts on paper or as a PDF';

  @override
  String get saveFailed => 'The account could not be saved. Try again.';

  @override
  String get scannerCameraDenied =>
      'The app is not allowed to use the camera. Allow it in the device settings, or enter the setup key instead.';

  @override
  String get scannerCameraUnavailable => 'The camera is not available. Enter the setup key instead.';

  @override
  String get scannerErrorInvalidSecret => 'This QR code has an invalid key.';

  @override
  String get scannerErrorMissingName => 'This QR code has no account name. Enter the setup key instead.';

  @override
  String get scannerErrorNotOtpAuth => 'This is not an authenticator QR code.';

  @override
  String get scannerErrorUnsupportedParameters => 'This QR code uses settings the app does not support.';

  @override
  String get scannerErrorUnsupportedType => 'Only time-based codes are supported.';

  @override
  String get scannerHint => 'Point the camera at the QR code shown by the service.';

  @override
  String get searchHint => 'Search accounts';

  @override
  String get setupStepEnable => 'Turn on two-factor authentication';

  @override
  String get setupStepEnableHint => 'In the security settings of the service you want to protect';

  @override
  String get setupStepScan => 'Scan the QR code it shows';

  @override
  String get setupStepScanHint => 'Or type the setup key next to it';

  @override
  String get setupStepSignIn => 'Sign in with the code';

  @override
  String get setupStepSignInHint => 'The app shows a new one every 30 seconds';

  @override
  String get setupTitle => 'Set up your first code';

  @override
  String get tapToCopy => 'Tap to copy';
}
