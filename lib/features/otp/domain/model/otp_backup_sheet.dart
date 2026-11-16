import 'dart:typed_data';

/// A backup sheet that is ready to be shown and printed.
class OtpBackupSheet {
  const OtpBackupSheet({required this.name, required this.accountCount, required this.pdf, required this.pages});

  final String name;
  final int accountCount;
  final Uint8List pdf;

  /// A PNG image of every page of [pdf].
  final List<Uint8List> pages;
}
