import 'package:app_core/app/data/repository/flutter_system_clipboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('setText puts the text on the device clipboard', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final calls = <MethodCall>[];
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(SystemChannels.platform, null));

    await const FlutterSystemClipboard().setText('123456');

    expect(calls.single.method, 'Clipboard.setData');
    expect(calls.single.arguments, {'text': '123456'});
  });
}
