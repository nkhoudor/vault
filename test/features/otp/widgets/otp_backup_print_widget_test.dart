import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_presenter.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_state.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

const _secret = OtpSecret(
  id: 'id',
  issuer: 'GitHub',
  secret: 'JBSWY3DPEHPK3PXP',
  period: 30,
  digits: 6,
  algorithm: OtpAlgorithm.sha1,
);

void main() {
  late MockOtpBackupPrintNavigator navigator;

  setUp(() {
    navigator = MockOtpBackupPrintNavigator();
    when(() => navigator.navigateToOtpBackupPreview()).thenAnswer((_) async {});
  });

  Future<void> pumpWidget(WidgetTester tester, List<OtpSecret> secrets) async {
    final repository = MockOtpBackupPrintRepository();
    when(() => repository.getOtpSecretsStream()).thenAnswer((_) => Stream.value(secrets));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        home: Scaffold(
          body: OtpBackupPrintWidget(
            presenter: OtpBackupPrintPresenter(const OtpBackupPrintState(), navigator, repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the row cannot be used while there are no accounts', (tester) async {
    await pumpWidget(tester, []);

    expect(find.text('Add an account to print a sheet'), findsOneWidget);
    await tester.tap(find.text('Print backup sheet'));

    verifyNever(() => navigator.navigateToOtpBackupPreview());
  });

  testWidgets('tapping the row opens the preview', (tester) async {
    await pumpWidget(tester, [_secret]);

    await tester.tap(find.text('Print backup sheet'));

    verify(() => navigator.navigateToOtpBackupPreview()).called(1);
  });
}
