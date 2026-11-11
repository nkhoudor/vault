import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'theme_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ThemeLocalizations
/// returned by `ThemeLocalizations.of(context)`.
///
/// Applications need to include `ThemeLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/theme_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ThemeLocalizations.localizationsDelegates,
///   supportedLocales: ThemeLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ThemeLocalizations.supportedLocales
/// property.
abstract class ThemeLocalizations {
  ThemeLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ThemeLocalizations? of(BuildContext context) {
    return Localizations.of<ThemeLocalizations>(context, ThemeLocalizations);
  }

  static const LocalizationsDelegate<ThemeLocalizations> delegate = _ThemeLocalizationsDelegate();

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

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @themeCozy.
  ///
  /// In en, this message translates to:
  /// **'Cozy'**
  String get themeCozy;

  /// No description provided for @themeCatppuccin.
  ///
  /// In en, this message translates to:
  /// **'Catppuccin'**
  String get themeCatppuccin;

  /// No description provided for @themeNord.
  ///
  /// In en, this message translates to:
  /// **'Nord'**
  String get themeNord;

  /// No description provided for @themeDracula.
  ///
  /// In en, this message translates to:
  /// **'Dracula'**
  String get themeDracula;

  /// No description provided for @themeTokyoNight.
  ///
  /// In en, this message translates to:
  /// **'Tokyo Night'**
  String get themeTokyoNight;

  /// No description provided for @themeGruvbox.
  ///
  /// In en, this message translates to:
  /// **'Gruvbox'**
  String get themeGruvbox;

  /// No description provided for @themeOneDark.
  ///
  /// In en, this message translates to:
  /// **'One Dark'**
  String get themeOneDark;
}

class _ThemeLocalizationsDelegate extends LocalizationsDelegate<ThemeLocalizations> {
  const _ThemeLocalizationsDelegate();

  @override
  Future<ThemeLocalizations> load(Locale locale) {
    return SynchronousFuture<ThemeLocalizations>(lookupThemeLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ThemeLocalizationsDelegate old) => false;
}

ThemeLocalizations lookupThemeLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ThemeLocalizationsEn();
  }

  throw FlutterError(
    'ThemeLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

extension L10nUtils on BuildContext {
  ThemeLocalizations get l10n => ThemeLocalizations.of(this)!;
}
