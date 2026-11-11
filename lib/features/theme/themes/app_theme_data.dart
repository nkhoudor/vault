import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/themes/catppuccin_color_scheme.dart';
import 'package:app_core/features/theme/themes/cozy_color_scheme.dart';
import 'package:app_core/features/theme/themes/dracula_color_scheme.dart';
import 'package:app_core/features/theme/themes/gruvbox_color_scheme.dart';
import 'package:app_core/features/theme/themes/nord_color_scheme.dart';
import 'package:app_core/features/theme/themes/one_dark_color_scheme.dart';
import 'package:app_core/features/theme/themes/text_themes.dart';
import 'package:app_core/features/theme/themes/tokyo_night_color_scheme.dart';
import 'package:flutter/material.dart';

/// The Flutter themes that draw an [AppTheme].
extension AppThemeData on AppTheme {
  ThemeData get lightThemeData => _themeData(_colorSchemes.light);

  ThemeData get darkThemeData => _themeData(_colorSchemes.dark);

  ({ColorScheme light, ColorScheme dark}) get _colorSchemes => switch (this) {
    AppTheme.cozy => (light: cozyLightColorScheme, dark: cozyDarkColorScheme),
    AppTheme.catppuccin => (light: catppuccinLightColorScheme, dark: catppuccinDarkColorScheme),
    AppTheme.nord => (light: nordLightColorScheme, dark: nordDarkColorScheme),
    AppTheme.dracula => (light: draculaLightColorScheme, dark: draculaDarkColorScheme),
    AppTheme.tokyoNight => (light: tokyoNightLightColorScheme, dark: tokyoNightDarkColorScheme),
    AppTheme.gruvbox => (light: gruvboxLightColorScheme, dark: gruvboxDarkColorScheme),
    AppTheme.oneDark => (light: oneDarkLightColorScheme, dark: oneDarkDarkColorScheme),
  };

  ThemeData _themeData(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: PredefinedTextTheme.common.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
  );
}

/// The Flutter theme mode that draws an [AppThemeMode].
extension AppThemeModeData on AppThemeMode {
  ThemeMode get flutterThemeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}
