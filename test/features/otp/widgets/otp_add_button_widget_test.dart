import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_presenter.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_state.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late MockOtpAddButtonNavigator navigator;

  setUp(() {
    navigator = MockOtpAddButtonNavigator();
    when(() => navigator.navigateToOtpScanner()).thenAnswer((_) async {});
    when(() => navigator.navigateToOtpManualEntry()).thenAnswer((_) async {});
  });

  Future<void> pumpAndOpenSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        home: Scaffold(
          floatingActionButton: OtpAddButtonWidget(
            presenter: OtpAddButtonPresenter(const OtpAddButtonState(), navigator),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  }

  testWidgets('choosing "Scan QR code" opens the scanner', (tester) async {
    await pumpAndOpenSheet(tester);

    await tester.tap(find.text('Scan QR code'));
    await tester.pumpAndSettle();

    verify(() => navigator.navigateToOtpScanner()).called(1);
    verifyNever(() => navigator.navigateToOtpManualEntry());
  });

  testWidgets('choosing "Enter setup key" opens manual entry', (tester) async {
    await pumpAndOpenSheet(tester);

    await tester.tap(find.text('Enter setup key'));
    await tester.pumpAndSettle();

    verify(() => navigator.navigateToOtpManualEntry()).called(1);
    verifyNever(() => navigator.navigateToOtpScanner());
  });

  testWidgets('dismissing the sheet navigates nowhere', (tester) async {
    await pumpAndOpenSheet(tester);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    verifyNever(() => navigator.navigateToOtpScanner());
    verifyNever(() => navigator.navigateToOtpManualEntry());
  });
}
