import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_presenter.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_state.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../helpers/golden_test_helpers.dart';

const _secret = OtpSecret(
  id: 'id',
  issuer: 'GitHub',
  secret: 'JBSWY3DPEHPK3PXP',
  period: 30,
  digits: 6,
  algorithm: OtpAlgorithm.sha1,
);

OtpBackupPrintWidget _widget(List<OtpSecret> secrets) {
  final repository = MockOtpBackupPrintRepository();
  when(() => repository.getOtpSecretsStream()).thenAnswer((_) => Stream.value(secrets));
  return OtpBackupPrintWidget(
    presenter: OtpBackupPrintPresenter(const OtpBackupPrintState(), MockOtpBackupPrintNavigator(), repository),
  );
}

void main() {
  goldenTest('otp_backup_print', builder: () => _widget([_secret]));

  goldenTest('otp_backup_print_no_accounts', builder: () => _widget([]));
}
