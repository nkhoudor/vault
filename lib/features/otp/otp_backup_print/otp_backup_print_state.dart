import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/otp/otp_backup_print/otp_backup_print_state.freezed.dart';

/// Represents the UI or business state for the "OtpBackupPrint" feature.
@freezed
abstract class OtpBackupPrintState with _$OtpBackupPrintState {
  const factory OtpBackupPrintState({
    /// Whether there is an account to put on a sheet.
    @Default(false) bool canPrint,
  }) = _OtpBackupPrintState;

  const OtpBackupPrintState._();

  /// Creates a [OtpBackupPrintState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory OtpBackupPrintState.fromInitialParams(OtpBackupPrintStateParams? initialParams) {
    return const OtpBackupPrintState();
  }
}

/// Represents the input data used to initialize a [OtpBackupPrintState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class OtpBackupPrintStateParams with _$OtpBackupPrintStateParams {
  const factory OtpBackupPrintStateParams() = _OtpBackupPrintStateParams;
}
