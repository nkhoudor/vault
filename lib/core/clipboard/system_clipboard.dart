/// Abstract contract for the device clipboard.
abstract interface class SystemClipboard {
  /// Replaces what is on the clipboard with [text].
  Future<void> setText(String text);
}
