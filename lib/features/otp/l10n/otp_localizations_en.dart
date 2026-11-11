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
  String get addOptionScanQrCode => 'Scan QR code';

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
}
