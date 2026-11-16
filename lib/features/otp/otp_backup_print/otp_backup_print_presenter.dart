import 'package:app_core/features/otp/otp_backup_print/domain/repository/otp_backup_print_repository.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_navigator.dart';
import 'package:app_core/features/otp/otp_backup_print/otp_backup_print_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpBackupPrintPresenter extends Cubit<OtpBackupPrintState> with SubscriptionsMixin {
  OtpBackupPrintPresenter(super.model, this._navigator, this._repository) {
    listenTo(
      stream: _repository.getOtpSecretsStream(),
      subscriptionId: _secretsStreamSubscription,
      onChange: (secrets) => tryEmit(state.copyWith(canPrint: secrets.isNotEmpty)),
    );
  }

  final OtpBackupPrintNavigator _navigator;
  final OtpBackupPrintRepository _repository;

  static const _secretsStreamSubscription = 'secretsStreamSubscription';

  Future<void> onPrintBackupPressed() => _navigator.navigateToOtpBackupPreview();
}
