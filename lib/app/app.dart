import 'package:app_core/app/l10n/app_localizations.dart';
import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/di/app_component.dart';
import 'package:app_core/features/theme/theme_builder/theme_builder_widget.dart';
import 'package:app_core/features/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilderWidget(
      builder: (appTheme, themeMode) => MaterialApp.router(
        routerConfig: DI.get<GoRouter>(),
        onGenerateTitle: (context) => context.l10n.appTitle,
        theme: appTheme.lightThemeData,
        darkTheme: appTheme.darkThemeData,
        themeMode: themeMode.flutterThemeMode,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      ),
    );
  }
}
