import 'dart:typed_data';

/// Abstract contract for showing and printing PDF documents with what the device offers.
abstract interface class DocumentPrinter {
  /// A PNG image of every page of the PDF in [bytes], for showing it on screen.
  Future<List<Uint8List>> renderPages(Uint8List bytes);

  /// Offers the PDF in [bytes] for printing or saving under [name].
  Future<void> sharePdf({required String name, required Uint8List bytes});
}
