import 'package:app_core/app/data/repository/system_document_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sharePdf on iOS hands the PDF to the channel that deletes its file after sharing', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    const channel = MethodChannel('app_core/pdf_share');
    final calls = <MethodCall>[];
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    final bytes = Uint8List.fromList('%PDF-'.codeUnits);

    await const SystemDocumentPrinter().sharePdf(name: 'Authenticator backup', bytes: bytes);

    expect(calls.single.method, 'sharePdf');
    expect(calls.single.arguments, {'name': 'Authenticator backup.pdf', 'bytes': bytes});
  });
}
