import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/model/otp_backup_sheet_texts.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_presenter.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_state.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../backup_sheet_texts.dart';

void main() {
  late MockOtpBackupPreviewRepository repository;

  setUpAll(() => registerFallbackValue(backupSheetTexts));

  setUp(() {
    repository = MockOtpBackupPreviewRepository();
    when(() => repository.buildBackupSheet(any())).thenAnswer((_) async => backupSheet);
    when(() => repository.shareBackupSheet(backupSheet)).thenAnswer((_) async {});
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        home: Scaffold(
          body: OtpBackupPreviewWidget(
            presenter: OtpBackupPreviewPresenter(
              const OtpBackupPreviewState(),
              MockOtpBackupPreviewNavigator(),
              repository,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder printButton() => find.widgetWithText(FilledButton, 'Print or save as PDF');

  testWidgets('shows the sheet, what it holds and a warning', (tester) async {
    await pumpWidget(tester);

    expect(find.text('Backup sheet'), findsOneWidget);
    expect(find.text('2 accounts · 1 page'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.textContaining('shows every setup key'), findsOneWidget);
  });

  testWidgets('the sheet is worded in the language of the app', (tester) async {
    await pumpWidget(tester);

    final texts = verify(() => repository.buildBackupSheet(captureAny())).captured.single as OtpBackupSheetTexts;
    expect(texts.title, 'Authenticator backup');
    expect(texts.summary(2, DateTime(2026, 11, 15)), '2 accounts · exported Nov 15, 2026');
    expect(texts.pageLabel(1, 3), 'Page 1 of 3');
    expect(texts.parametersLabel('SHA256', 8, 60), 'SHA256 · 8 digits · 60 s');
  });

  testWidgets('nothing is printed until the button is pressed', (tester) async {
    await pumpWidget(tester);

    verifyNever(() => repository.shareBackupSheet(backupSheet));

    await tester.tap(printButton());
    await tester.pumpAndSettle();

    verify(() => repository.shareBackupSheet(backupSheet)).called(1);
  });

  testWidgets('the button waits for the sheet, and a sheet that cannot be prepared says so', (tester) async {
    when(() => repository.buildBackupSheet(any())).thenThrow(Exception('no renderer'));

    await pumpWidget(tester);

    expect(find.text('The sheet could not be prepared. Try again.'), findsOneWidget);
    expect(tester.widget<FilledButton>(printButton()).onPressed, isNull);
  });

  testWidgets('says so when the sheet could not be printed', (tester) async {
    when(() => repository.shareBackupSheet(backupSheet)).thenThrow(Exception('no printer'));
    await pumpWidget(tester);

    await tester.tap(printButton());
    await tester.pumpAndSettle();

    expect(find.text('The sheet could not be printed. Try again.'), findsOneWidget);
  });
}
