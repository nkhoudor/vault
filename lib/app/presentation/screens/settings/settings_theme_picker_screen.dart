import 'package:app_core/app/l10n/app_localizations.dart';
import 'package:app_core/app/presentation/routes/app_route_annotation.dart';
import 'package:app_core/app/presentation/routes/route_name.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_widget.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_widget.dart';
import 'package:flutter/material.dart';

@AppRoute(name: RouteName.themePicker, parent: RouteName.settings)
class SettingsThemePickerScreen extends StatelessWidget {
  const SettingsThemePickerScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBarWidget(title: context.l10n.themePicker),
    body: const ThemePickerWidget(),
  );
}
