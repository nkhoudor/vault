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
    test('is the primary color, then blends into the error color between the last fifth and the last tenth', () {
      const colorScheme = ColorScheme.light();
      int colorAt(double remaining) => OtpCountdownRing.colorFor(remaining, colorScheme).toARGB32();

      expect(colorAt(1), colorScheme.primary.toARGB32());
      expect(colorAt(0.2), colorScheme.primary.toARGB32());
      expect(colorAt(0.15), Color.lerp(colorScheme.primary, colorScheme.error, 0.5)!.toARGB32());
      expect(colorAt(0.1), colorScheme.error.toARGB32());
      expect(colorAt(0), colorScheme.error.toARGB32());
    });
  });
}
