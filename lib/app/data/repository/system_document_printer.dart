import 'package:app_core/core/printing/document_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// [DocumentPrinter] implementation backed by the system PDF renderer.
///
/// On iOS the PDF goes to the share sheet, which prints it and saves it to Files: the print dialog opened directly
/// draws an empty preview there. The share sheet needs a file, so the app's own channel writes one and deletes it
/// when the sheet closes. Elsewhere the PDF goes to the system print dialog, which can also save it.
class SystemDocumentPrinter implements DocumentPrinter {
  const SystemDocumentPrinter();

  static const _previewDpi = 110.0;
  static const _shareChannel = MethodChannel('app_core/pdf_share');

  @override
  Future<List<Uint8List>> renderPages(Uint8List bytes) async => [
    await for (final page in Printing.raster(bytes, dpi: _previewDpi)) await page.toPng(),
  ];

  @override
  Future<void> sharePdf({required String name, required Uint8List bytes}) => defaultTargetPlatform == TargetPlatform.iOS
      ? _shareChannel.invokeMethod<void>('sharePdf', {'name': '$name.pdf', 'bytes': bytes})
      : Printing.layoutPdf(name: name, format: PdfPageFormat.a4, onLayout: (_) => bytes);
}
