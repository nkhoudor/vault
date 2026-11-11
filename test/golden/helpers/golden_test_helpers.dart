import 'dart:math' show max;

import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Predefined screen sizes for golden tests (logical pixels, portrait).
enum ScreenSize {
  iPhoneSE(Size(375, 667), 'iPhone SE'),
  iPhone17(Size(402, 874), 'iPhone 17'),
  iPhone17ProMax(Size(440, 956), 'iPhone 17 Pro Max'),
  tablet(Size(768, 1024), 'Tablet');

  const ScreenSize(this.size, this.label);
  final Size size;
  final String label;
}

/// Tag on every golden test. Golden images depend on the machine that rendered them,
/// so CI runs `flutter test --exclude-tags golden` and they stay a local check.
const goldenTag = 'golden';

const double _kGoldenBorderWidth = 2.0;
const double _kGoldenTileGap = 16.0;
const double _kGoldenTitleHeight = 24.0;

/// Renders [builder] at every [screenSizes] **side by side** in a single golden
/// image saved as `goldens/{name}.png`.
///
/// ```dart
/// void main() {
///   goldenTest(
///     'my_widget',
///     builder: () => MyWidget(presenter: ...),
///   );
/// }
/// ```
void goldenTest(
  String name, {
  required Widget Function() builder,
  List<ScreenSize> screenSizes = const [
    ScreenSize.iPhoneSE,
    ScreenSize.iPhone17,
    ScreenSize.iPhone17ProMax,
    ScreenSize.tablet,
  ],
}) {
  testWidgets(name, (tester) async {
    final totalWidth =
        screenSizes.fold<double>(0.0, (sum, s) => sum + s.size.width + 2 * _kGoldenBorderWidth + _kGoldenTileGap) -
        _kGoldenTileGap;
    final maxContentHeight = screenSizes.map((s) => s.size.height).reduce(max);
    final totalHeight = _kGoldenTitleHeight + maxContentHeight + 2 * _kGoldenBorderWidth;

    tester.view.physicalSize = Size(totalWidth, totalHeight);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_GoldenTestApp(screenSizes: screenSizes, builder: builder));
    await tester.pumpAndSettle();

    await expectLater(find.byType(_GoldenTestApp), matchesGoldenFile('goldens/$name.png'));
  }, tags: goldenTag);
}

/// Renders [builder] in light and dark theme **side by side** in a single golden
/// image saved as `goldens/{name}.png`. Uses [screenSize] for both tiles.
///
/// Use this to catch theme regressions (e.g. contrast, colors in dark mode).
void goldenTestThemed(
  String name, {
  required Widget Function() builder,
  List<ThemeMode> themeModes = const [ThemeMode.light, ThemeMode.dark],
  ScreenSize screenSize = ScreenSize.iPhone17,
}) {
  testWidgets(name, (tester) async {
    final totalWidth =
        themeModes.length * (screenSize.size.width + 2 * _kGoldenBorderWidth + _kGoldenTileGap) - _kGoldenTileGap;
    final totalHeight = _kGoldenTitleHeight + screenSize.size.height + 2 * _kGoldenBorderWidth;

    tester.view.physicalSize = Size(totalWidth, totalHeight);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_GoldenTestThemedApp(themeModes: themeModes, screenSize: screenSize, builder: builder));
    await tester.pumpAndSettle();

    await expectLater(find.byType(_GoldenTestThemedApp), matchesGoldenFile('goldens/$name.png'));
  }, tags: goldenTag);
}

class _GoldenTestApp extends StatelessWidget {
  const _GoldenTestApp({required this.screenSizes, required this.builder});

  final List<ScreenSize> screenSizes;
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < screenSizes.length; i++) ...[
            if (i > 0) const SizedBox(width: _kGoldenTileGap),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: [
                SizedBox(
                  height: _kGoldenTitleHeight,
                  child: Text(
                    screenSizes[i].label,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF424242),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF9E9E9E), width: _kGoldenBorderWidth),
                  ),
                  child: SizedBox(
                    width: screenSizes[i].size.width,
                    height: screenSizes[i].size.height,
                    child: MaterialApp(
                      theme: AppTheme.cozy.lightThemeData,
                      debugShowCheckedModeBanner: false,
                      locale: supportedLocales.first,
                      localizationsDelegates: localizationsDelegates,
                      supportedLocales: supportedLocales,
                      home: Scaffold(body: builder()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _GoldenTestThemedApp extends StatelessWidget {
  const _GoldenTestThemedApp({required this.themeModes, required this.screenSize, required this.builder});

  final List<ThemeMode> themeModes;
  final ScreenSize screenSize;
  final Widget Function() builder;

  static String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  static ThemeData _themeFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppTheme.cozy.lightThemeData;
      case ThemeMode.dark:
        return AppTheme.cozy.darkThemeData;
      case ThemeMode.system:
        return AppTheme.cozy.lightThemeData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < themeModes.length; i++) ...[
            if (i > 0) const SizedBox(width: _kGoldenTileGap),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: [
                SizedBox(
                  height: _kGoldenTitleHeight,
                  child: Text(
                    _themeModeLabel(themeModes[i]),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF424242),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF9E9E9E), width: _kGoldenBorderWidth),
                  ),
                  child: SizedBox(
                    width: screenSize.size.width,
                    height: screenSize.size.height,
                    child: MaterialApp(
                      theme: _themeFor(themeModes[i]),
                      debugShowCheckedModeBanner: false,
                      locale: supportedLocales.first,
                      localizationsDelegates: localizationsDelegates,
                      supportedLocales: supportedLocales,
                      home: Scaffold(body: builder()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
