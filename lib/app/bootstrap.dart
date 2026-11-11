import 'dart:io';

import 'package:app_core/app/app.dart';
import 'package:app_core/core/logs.dart';
import 'package:app_core/core/uncaught_errors.dart';
import 'package:app_core/di/app_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  logUncaughtErrors();

  await Future.wait([
    if (Platform.isAndroid) SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    Logs.initialize(),
  ]);

  Logs.d('Starting app');

  await DI.configureDependencies();

  runApp(const App());
}
