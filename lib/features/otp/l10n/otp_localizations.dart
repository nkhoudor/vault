import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'otp_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OtpLocalizations
/// returned by `OtpLocalizations.of(context)`.
///
/// Applications need to include `OtpLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/otp_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OtpLocalizations.localizationsDelegates,
///   supportedLocales: OtpLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the OtpLocalizations.supportedLocales
/// property.
abstract class OtpLocalizations {
  OtpLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OtpLocalizations? of(BuildContext context) {
    return Localizations.of<OtpLocalizations>(context, OtpLocalizations);
  }

  static const LocalizationsDelegate<OtpLocalizations> delegate = _OtpLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccount;

  /// No description provided for @addOptionEnterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter setup key'**
  String get addOptionEnterManually;

  /// No description provided for @addOptionScanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get addOptionScanQrCode;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @codeCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopiedToClipboard;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'The code for {name} will be removed from this device. Make sure you can still sign in to that account without it.'**
  String deleteOtpMessage(String name);

  /// No description provided for @deleteOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this code?'**
  String get deleteOtpTitle;

  /// No description provided for @manualEntryAccountHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get manualEntryAccountHint;

  /// No description provided for @manualEntryAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account (optional)'**
  String get manualEntryAccountLabel;

  /// No description provided for @manualEntryIssuerHint.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get manualEntryIssuerHint;

  /// No description provided for @manualEntryIssuerLabel.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get manualEntryIssuerLabel;

  /// No description provided for @manualEntryIssuerRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of the service.'**
  String get manualEntryIssuerRequired;

  /// No description provided for @manualEntrySave.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get manualEntrySave;

  /// No description provided for @manualEntrySecretKeyHelper.
  ///
  /// In en, this message translates to:
  /// **'The key the service shows next to its QR code.'**
  String get manualEntrySecretKeyHelper;

  /// No description provided for @manualEntrySecretKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'This is not a valid setup key. It can only contain the letters A–Z and the digits 2–7.'**
  String get manualEntrySecretKeyInvalid;

  /// No description provided for @manualEntrySecretKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Setup key'**
  String get manualEntrySecretKeyLabel;

  /// No description provided for @noMatchingAccounts.
  ///
  /// In en, this message translates to:
  /// **'No matching accounts'**
  String get noMatchingAccounts;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'The account could not be saved. Try again.'**
  String get saveFailed;

  /// No description provided for @scannerCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'The app is not allowed to use the camera. Allow it in the device settings, or enter the setup key instead.'**
  String get scannerCameraDenied;

  /// No description provided for @scannerCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The camera is not available. Enter the setup key instead.'**
  String get scannerCameraUnavailable;

  /// No description provided for @scannerErrorInvalidSecret.
  ///
  /// In en, this message translates to:
  /// **'This QR code has an invalid key.'**
  String get scannerErrorInvalidSecret;

  /// No description provided for @scannerErrorMissingName.
  ///
  /// In en, this message translates to:
  /// **'This QR code has no account name. Enter the setup key instead.'**
  String get scannerErrorMissingName;

  /// No description provided for @scannerErrorNotOtpAuth.
  ///
  /// In en, this message translates to:
  /// **'This is not an authenticator QR code.'**
  String get scannerErrorNotOtpAuth;

  /// No description provided for @scannerErrorUnsupportedParameters.
  ///
  /// In en, this message translates to:
  /// **'This QR code uses settings the app does not support.'**
  String get scannerErrorUnsupportedParameters;

  /// No description provided for @scannerErrorUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'Only time-based codes are supported.'**
  String get scannerErrorUnsupportedType;

  /// No description provided for @scannerHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code shown by the service.'**
  String get scannerHint;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search accounts'**
  String get searchHint;
}

class _OtpLocalizationsDelegate extends LocalizationsDelegate<OtpLocalizations> {
  const _OtpLocalizationsDelegate();

  @override
  Future<OtpLocalizations> load(Locale locale) {
    return SynchronousFuture<OtpLocalizations>(lookupOtpLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_OtpLocalizationsDelegate old) => false;
}

OtpLocalizations lookupOtpLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return OtpLocalizationsEn();
  }

  throw FlutterError(
    'OtpLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

extension L10nUtils on BuildContext {
  OtpLocalizations get l10n => OtpLocalizations.of(this)!;
}
