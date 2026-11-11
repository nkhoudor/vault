import 'package:logger/logger.dart';

class Logs {
  // Call it before using Logs
  static Future<void> initialize({bool enableProductionLogging = false}) async {
    _AppLogger.initialize(filter: enableProductionLogging ? _ShowEverythingFilter() : DevelopmentFilter());
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _AppLogger.logs.d(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _AppLogger.logs.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _AppLogger.logs.e(message, error: error, stackTrace: stackTrace);
  }
}

class _ShowEverythingFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class _AppLogger extends Logger {
  _AppLogger._({super.filter}) : super(printer: SimplePrinter(printTime: true));

  static _AppLogger? _instance;
  static _AppLogger get logs => _instance ??= _AppLogger._();

  static void initialize({LogFilter? filter}) {
    _instance = _AppLogger._(filter: filter);
  }
}
