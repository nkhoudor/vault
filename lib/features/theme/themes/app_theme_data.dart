import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/themes/catppuccin_color_scheme.dart';
import 'package:app_core/features/theme/themes/cozy_color_scheme.dart';
import 'package:app_core/features/theme/themes/dracula_color_scheme.dart';
import 'package:app_core/features/theme/themes/gruvbox_color_scheme.dart';
import 'package:app_core/features/theme/themes/mint_color_scheme.dart';
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
    AppTheme.mint => (light: mintLightColorScheme, dark: mintDarkColorScheme),
  };

  ThemeData _themeData(ColorScheme colorScheme) {
    final textTheme = PredefinedTextTheme.common.textTheme.apply(
      fontFamily: _fontFamily,
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    const pill = StadiumBorder();
    const buttonSize = Size(64, 52);
    OutlineInputBorder fieldBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: 2),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      fontFamily: _fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: buttonSize, shape: pill, textStyle: textTheme.titleMedium),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: pill,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outlineVariant, width: 2),
          textStyle: textTheme.titleMedium,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(),
        sizeConstraints: const BoxConstraints.tightFor(width: 52, height: 52),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          minimumSize: buttonSize,
          side: BorderSide.none,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
          selectedBackgroundColor: colorScheme.primary,
          selectedForegroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: fieldBorder(colorScheme.outlineVariant),
        enabledBorder: fieldBorder(colorScheme.outlineVariant),
        disabledBorder: fieldBorder(colorScheme.outlineVariant),
        focusedBorder: fieldBorder(colorScheme.primary),
        errorBorder: fieldBorder(colorScheme.error),
        focusedErrorBorder: fieldBorder(colorScheme.error),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
        constraints: const BoxConstraints(minHeight: 52, maxHeight: 52),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 18)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        modalBackgroundColor: colorScheme.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: pill),
    );
  }

  static const _fontFamily = 'Sora';
}

/// The Flutter theme mode that draws an [AppThemeMode].
extension AppThemeModeData on AppThemeMode {
  ThemeMode get flutterThemeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}
