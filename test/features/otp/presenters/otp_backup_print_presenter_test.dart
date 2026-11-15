import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_presenter.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_state.dart';
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
  late MockOtpBackupPrintRepository repository;
  late MockOtpBackupPrintNavigator navigator;

  setUp(() {
    repository = MockOtpBackupPrintRepository();
    navigator = MockOtpBackupPrintNavigator();
    when(() => navigator.navigateToOtpBackupPreview()).thenAnswer((_) async {});
  });

  Future<OtpBackupPrintPresenter> buildPresenter(List<OtpSecret> secrets) async {
    when(() => repository.getOtpSecretsStream()).thenAnswer((_) => Stream.value(secrets));
    final presenter = OtpBackupPrintPresenter(const OtpBackupPrintState(), navigator, repository);
    await Future<void>.delayed(Duration.zero);
    return presenter;
  }

  test('can print once there is an account', () async {
    expect((await buildPresenter([])).state.canPrint, isFalse);
    expect((await buildPresenter([_secret])).state.canPrint, isTrue);
  });

  test('onPrintBackupPressed opens the preview', () async {
    final presenter = await buildPresenter([_secret]);

    await presenter.onPrintBackupPressed();

    verify(() => navigator.navigateToOtpBackupPreview()).called(1);
  });
}
