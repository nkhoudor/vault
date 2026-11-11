import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_presenter.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_state.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late MockOtpManualEntryNavigator navigator;
  late MockOtpManualEntryRepository repository;

  setUpAll(
    () => registerFallbackValue(
      const OtpSecret(id: '', issuer: '', secret: '', period: 30, digits: 6, algorithm: OtpAlgorithm.sha1),
    ),
  );

  setUp(() {
    navigator = MockOtpManualEntryNavigator();
    repository = MockOtpManualEntryRepository();
    when(() => navigator.navigateBack()).thenAnswer((_) async {});
    when(() => repository.addSecret(any())).thenAnswer((_) async {});
  });

  Future<void> pumpForm(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      home: Scaffold(
        body: OtpManualEntryWidget(
          presenter: OtpManualEntryPresenter(OtpManualEntryState.empty(), navigator, repository),
        ),
      ),
    ),
  );

  Finder field(String label) => find.widgetWithText(TextField, label);
  final saveButton = find.widgetWithText(FilledButton, 'Add account');

  testWidgets('saving a filled form stores the secret and goes back', (tester) async {
    await pumpForm(tester);

    await tester.enterText(field('Service'), 'GitHub');
    await tester.enterText(field('Account (optional)'), 'alice@example.com');
    await tester.enterText(field('Setup key'), 'jbsw y3dp ehpk 3pxp');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final stored = verify(() => repository.addSecret(captureAny())).captured.single as OtpSecret;
    expect((stored.issuer, stored.account, stored.secret), ('GitHub', 'alice@example.com', 'JBSWY3DPEHPK3PXP'));
    verify(() => navigator.navigateBack()).called(1);
  });

  testWidgets('shows no errors before the first save attempt', (tester) async {
    await pumpForm(tester);

    expect(find.text('Enter the name of the service.'), findsNothing);
    expect(find.textContaining('not a valid setup key'), findsNothing);
  });

  testWidgets('saving an empty form shows both errors and stores nothing', (tester) async {
    await pumpForm(tester);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Enter the name of the service.'), findsOneWidget);
    expect(find.textContaining('not a valid setup key'), findsOneWidget);
    verifyNever(() => repository.addSecret(any()));
  });

  testWidgets('shows a message when the secret could not be stored', (tester) async {
    when(() => repository.addSecret(any())).thenThrow(Exception('storage unavailable'));
    await pumpForm(tester);

    await tester.enterText(field('Service'), 'GitHub');
    await tester.enterText(field('Setup key'), 'JBSWY3DPEHPK3PXP');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('The account could not be saved. Try again.'), findsOneWidget);
    verifyNever(() => navigator.navigateBack());
  });
}
