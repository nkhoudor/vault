import 'package:app_core/core/clipboard/system_clipboard.dart';
import 'package:flutter/services.dart';

/// [SystemClipboard] implementation backed by Flutter's [Clipboard].
class FlutterSystemClipboard implements SystemClipboard {
  const FlutterSystemClipboard();

  @override
  Future<void> setText(String text) => Clipboard.setData(ClipboardData(text: text));
}
