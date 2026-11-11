import 'package:app_core/core/logs.dart';
import 'package:flutter/foundation.dart';

/// Sends every error that nothing else caught to [Logs].
void logUncaughtErrors() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Logs.e('Uncaught Flutter error', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    Logs.e('Uncaught error', error, stackTrace);
    return true;
  };
}
