import 'dart:math';

import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:app_core/features/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The WCAG contrast ratio of two colors, from 1 (the same) to 21 (black on white).
double _contrast(Color a, Color b) {
  final lighter = max(a.computeLuminance(), b.computeLuminance());
  final darker = min(a.computeLuminance(), b.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  for (final mode in AppThemeMode.values) {
    test('$mode draws the Flutter theme mode of the same name', () {
      expect(mode.flutterThemeMode.name, mode.name);
    });
  }

  for (final theme in AppTheme.values) {
    for (final data in [theme.lightThemeData, theme.darkThemeData]) {
      final colors = data.colorScheme;

      group('${theme.name} ${colors.brightness.name}', () {
        test('the code reads at a glance', () {
          expect(_contrast(colors.onSurface, colors.surface), greaterThanOrEqualTo(7));
        });

        test('small text reads on the screen and on a card', () {
          expect(_contrast(colors.onSurfaceVariant, colors.surface), greaterThanOrEqualTo(4.5));
          expect(_contrast(colors.onSurfaceVariant, colors.surfaceContainerHigh), greaterThanOrEqualTo(4.5));
        });

        test('the icon of the add button reads on the button', () {
          expect(_contrast(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
        });

        test('the countdown ring and its warning color stand out from the screen', () {
          expect(_contrast(colors.primary, colors.surface), greaterThanOrEqualTo(3));
          expect(_contrast(colors.error, colors.surface), greaterThanOrEqualTo(3));
        });

        test('an account chip has an outline that shows', () {
          expect(_contrast(colors.outlineVariant, colors.surfaceContainerHigh), greaterThanOrEqualTo(1.2));
        });
      });
    }
  }
}
