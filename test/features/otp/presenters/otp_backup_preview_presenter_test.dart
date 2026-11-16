import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_presenter.dart';
import 'package:app_core/features/otp/otp_backup_preview/otp_backup_preview_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../backup_sheet_texts.dart';

void main() {
  late MockOtpBackupPreviewRepository repository;
  late OtpBackupPreviewPresenter presenter;

  setUp(() {
    repository = MockOtpBackupPreviewRepository();
    when(() => repository.buildBackupSheet(backupSheetTexts)).thenAnswer((_) async => backupSheet);
    when(() => repository.shareBackupSheet(backupSheet)).thenAnswer((_) async {});
    presenter = OtpBackupPreviewPresenter(const OtpBackupPreviewState(), MockOtpBackupPreviewNavigator(), repository);
  });

  test('onSheetTextsChanged lays out the sheet', () async {
    await presenter.onSheetTextsChanged(backupSheetTexts);

    expect(presenter.state.sheet, backupSheet);
    expect(presenter.state.previewFailed, isFalse);
  });

  test('onSheetTextsChanged reports a sheet that could not be laid out', () async {
    when(() => repository.buildBackupSheet(backupSheetTexts)).thenThrow(Exception('no renderer'));

    await presenter.onSheetTextsChanged(backupSheetTexts);

    expect(presenter.state.sheet, isNull);
    expect(presenter.state.previewFailed, isTrue);
  });

  test('onSheetTextsChanged reports a sheet whose font could not be loaded', () async {
    when(() => repository.buildBackupSheet(backupSheetTexts)).thenThrow(FlutterError('Unable to load asset'));

    await presenter.onSheetTextsChanged(backupSheetTexts);

    expect(presenter.state.previewFailed, isTrue);
  });

  test('onPrintPressed prints the previewed sheet', () async {
    await presenter.onSheetTextsChanged(backupSheetTexts);

    await presenter.onPrintPressed();

    verify(() => repository.shareBackupSheet(backupSheet)).called(1);
    expect(presenter.state.printFailed, isFalse);
  });

  test('onPrintPressed does nothing while there is no sheet', () async {
    await presenter.onPrintPressed();

    verifyNever(() => repository.shareBackupSheet(backupSheet));
  });

  test('onPrintPressed reports a failed print, and a later success clears it', () async {
    await presenter.onSheetTextsChanged(backupSheetTexts);
    when(() => repository.shareBackupSheet(backupSheet)).thenThrow(Exception('no printer'));

    await presenter.onPrintPressed();
    expect(presenter.state.printFailed, isTrue);

    when(() => repository.shareBackupSheet(backupSheet)).thenAnswer((_) async {});
    await presenter.onPrintPressed();
    expect(presenter.state.printFailed, isFalse);
  });
}
