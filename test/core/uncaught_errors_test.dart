import 'dart:ui';

import 'package:app_core/core/uncaught_errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final logged = <LogEvent>[];
  void onLog(LogEvent event) => logged.add(event);

  late FlutterExceptionHandler? flutterOnError;
  late FlutterExceptionHandler flutterPresentError;
  late ErrorCallback? platformOnError;

  setUp(() {
    logged.clear();
    Logger.addLogListener(onLog);
    flutterOnError = FlutterError.onError;
    flutterPresentError = FlutterError.presentError;
    platformOnError = PlatformDispatcher.instance.onError;
    logUncaughtErrors();
  });

  tearDown(() {
    Logger.removeLogListener(onLog);
    FlutterError.onError = flutterOnError;
    FlutterError.presentError = flutterPresentError;
    PlatformDispatcher.instance.onError = platformOnError;
  });

  test('logs a framework error and still presents it', () {
    final error = Exception('build failed');
    final stackTrace = StackTrace.current;
    final presented = <FlutterErrorDetails>[];
    FlutterError.presentError = presented.add;
    final details = FlutterErrorDetails(exception: error, stack: stackTrace);

    FlutterError.onError!(details);

    expect(presented, [details]);
    expect(logged.single.level, Level.error);
    expect(logged.single.error, error);
    expect(logged.single.stackTrace, stackTrace);
  });

  test('logs an error from outside the framework and marks it as handled', () {
    final error = Exception('stream failed');
    final stackTrace = StackTrace.current;

    final handled = PlatformDispatcher.instance.onError!(error, stackTrace);

    expect(handled, isTrue);
    expect(logged.single.level, Level.error);
    expect(logged.single.error, error);
    expect(logged.single.stackTrace, stackTrace);
  });
}
