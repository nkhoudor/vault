import 'package:app_core/features/otp/domain/model/otp_backup_sheet_texts.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/use_case/build_otp_auth_uri_use_case.dart';
import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Lays accounts out as an A4 PDF: per account a QR code any authenticator app can scan and the key to type.
class OtpBackupSheetBuilder {
  const OtpBackupSheetBuilder(this._buildOtpAuthUri);

  final BuildOtpAuthUriUseCase _buildOtpAuthUri;

  static const accountsPerPage = _columns * _rows;

  static const _columns = 3;
  static const _rows = 5;
  static const _gap = 9.0;
  static const _qrSize = 63.0;
  static const _longKeyLength = 64;
  static const _muted = PdfColor.fromInt(0xff555555);

  /// [key] in groups of four characters, a few groups per line, so it can be read and typed without losing the place.
  static List<String> keyLines(String key) {
    final groups = [for (var i = 0; i < key.length; i += 4) key.substring(i, (i + 4).clamp(0, key.length))];
    return groups.slices(key.length > _longKeyLength ? 6 : 4).map((line) => line.join(' ')).toList();
  }

  Future<Uint8List> call(List<OtpSecret> secrets, OtpBackupSheetTexts texts) async {
    final document = pw.Document(
      title: texts.title,
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle.load('assets/fonts/Sora-Regular.ttf')),
        bold: pw.Font.ttf(await rootBundle.load('assets/fonts/Sora-SemiBold.ttf')),
        // Sora only has Latin letters; names in Greek or Cyrillic are drawn with Noto Sans.
        fontFallback: [pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'))],
      ),
    );
    final pages = secrets.slices(accountsPerPage).toList();

    for (final (index, page) in pages.indexed) {
      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(36),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _header(texts, secrets.length),
              pw.SizedBox(height: 15),
              for (final (rowIndex, row) in _rowsOf(page).indexed) ...[
                if (rowIndex > 0) pw.SizedBox(height: _gap),
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      for (final (columnIndex, secret) in row.indexed) ...[
                        if (columnIndex > 0) pw.SizedBox(width: _gap),
                        pw.Expanded(child: secret == null ? pw.SizedBox() : _card(secret, texts)),
                      ],
                    ],
                  ),
                ),
              ],
              pw.SizedBox(height: 15),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(texts.footer, style: const pw.TextStyle(fontSize: 8, color: _muted)),
                  pw.Text(
                    texts.pageLabel(index + 1, pages.length),
                    style: const pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return document.save();
  }

  /// The accounts of one page as full rows; the places after the last account are null.
  List<List<OtpSecret?>> _rowsOf(List<OtpSecret> page) => [
    for (var row = 0; row < _rows; row++)
      [for (var column = 0; column < _columns; column++) page.elementAtOrNull(row * _columns + column)],
  ];

  pw.Widget _header(OtpBackupSheetTexts texts, int accountCount) => pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(texts.title, style: pw.TextStyle(fontSize: 16.5, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 3),
          pw.Text(texts.summary(accountCount, clock.now()), style: const pw.TextStyle(fontSize: 10, color: _muted)),
        ],
      ),
      pw.Container(
        width: 218,
        padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.75)),
        child: pw.Text(texts.warning, style: const pw.TextStyle(fontSize: 9)),
      ),
    ],
  );

  pw.Widget _card(OtpSecret secret, OtpBackupSheetTexts texts) => pw.Container(
    padding: const pw.EdgeInsets.all(9),
    decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.75)),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(errorCorrectLevel: pw.BarcodeQRCorrectionLevel.medium),
              data: _buildOtpAuthUri(secret),
              width: _qrSize,
              height: _qrSize,
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (secret.issuer.isNotEmpty)
                    pw.Text(
                      secret.issuer,
                      maxLines: 2,
                      style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    ),
                  if (secret.account.isNotEmpty)
                    pw.Text(secret.account, maxLines: 3, style: const pw.TextStyle(fontSize: 8, color: _muted)),
                  if (!secret.hasDefaultParameters)
                    pw.Text(
                      texts.parametersLabel(secret.algorithm.name.toUpperCase(), secret.digits, secret.period),
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                ],
              ),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (final line in keyLines(secret.secret))
              pw.Text(
                line,
                style: pw.TextStyle(font: pw.Font.courier(), fontSize: secret.secret.length > _longKeyLength ? 7.5 : 9),
              ),
          ],
        ),
      ],
    ),
  );
}
