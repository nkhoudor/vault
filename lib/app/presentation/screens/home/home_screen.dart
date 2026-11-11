import 'package:app_core/app/l10n/app_localizations.dart';
import 'package:app_core/app/presentation/routes/app_route_annotation.dart';
import 'package:app_core/app/presentation/routes/route_name.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_widget.dart';
import 'package:app_core/features/otp/otp_list/otp_list_widget.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

@AppRoute(name: RouteName.home, path: '/')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: context.l10n.appTitle, showSettings: true),
      body: const OtpListWidget(),
      floatingActionButton: const OtpAddButtonWidget(),
    );
  }
}
