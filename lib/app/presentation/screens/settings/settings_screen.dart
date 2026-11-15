import 'package:app_core/app/l10n/app_localizations.dart';
import 'package:app_core/app/presentation/routes/app_route_annotation.dart';
import 'package:app_core/app/presentation/routes/route_name.dart';
import 'package:app_core/features/settings/settings_theme_picker/settings_theme_picker_widget.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_widget.dart';
import 'package:app_core/features/theme/theme_mode_switch/theme_mode_switch_widget.dart';
import 'package:flutter/material.dart';

@AppRoute(name: RouteName.settings, parent: RouteName.home)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: context.l10n.settings),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ThemeModeSwitchWidget(), SizedBox(height: 20), SettingsThemePickerWidget()],
        ),
      ),
    );
  }
}
