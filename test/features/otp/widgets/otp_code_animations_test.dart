import 'package:app_core/features/otp/otp_list/widgets/otp_code_digit.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_code_text.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_countdown_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {bool reduceMotion = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduceMotion),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group('OtpCodeText', () {
    Finder digitTexts() => find.descendant(of: find.byType(OtpCodeText), matching: find.byType(Text));

    testWidgets('shows one digit per character and reads the code digit by digit', (tester) async {
      await tester.pumpWidget(_app(const OtpCodeText(code: '123456')));

      expect(find.byType(OtpCodeDigit), findsNWidgets(6));
      expect(find.bySemanticsLabel('1 2 3 4 5 6'), findsOneWidget);
    });

    testWidgets('only the digits that changed roll over', (tester) async {
      await tester.pumpWidget(_app(const OtpCodeText(code: '123456')));

      await tester.pumpWidget(_app(const OtpCodeText(code: '123499')));
      await tester.pump(const Duration(milliseconds: 100));

      // Two positions show the old and the new digit at once; the other four are untouched.
      expect(digitTexts(), findsNWidgets(8));

      await tester.pumpAndSettle();
      expect(digitTexts(), findsNWidgets(6));
      expect(find.text('9'), findsNWidgets(2));
    });

    testWidgets('changes at once when the system asks to reduce motion', (tester) async {
      await tester.pumpWidget(_app(const OtpCodeText(code: '123456'), reduceMotion: true));

      await tester.pumpWidget(_app(const OtpCodeText(code: '654321'), reduceMotion: true));
      await tester.pump();

      expect(digitTexts(), findsNWidgets(6));
    });
  });

  group('OtpCountdownRing.colorFor', () {
    test('is green for the first half, red at the end and blends in between', () {
      expect(OtpCountdownRing.colorFor(1), Colors.green);
      expect(OtpCountdownRing.colorFor(0.5), Colors.green);
      expect(OtpCountdownRing.colorFor(0.25).toARGB32(), Colors.orange.toARGB32());
      expect(OtpCountdownRing.colorFor(0.05), Colors.red);

      final blend = OtpCountdownRing.colorFor(0.4);
      expect(blend, isNot(Colors.green));
      expect(blend.toARGB32(), isNot(Colors.orange.toARGB32()));
    });
  });
}
