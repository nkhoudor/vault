import 'package:app_core/features/otp/domain/model/otp_backup_sheet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/otp/otp_backup_preview/otp_backup_preview_state.freezed.dart';

/// Represents the UI or business state for the "OtpBackupPreview" feature.
@freezed
abstract class OtpBackupPreviewState with _$OtpBackupPreviewState {
  const factory OtpBackupPreviewState({
    /// The sheet being previewed, once it has been laid out.
    OtpBackupSheet? sheet,
    @Default(false) bool previewFailed,
    @Default(false) bool printFailed,
  }) = _OtpBackupPreviewState;

  const OtpBackupPreviewState._();

  /// Creates a [OtpBackupPreviewState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory OtpBackupPreviewState.fromInitialParams(OtpBackupPreviewStateParams? initialParams) {
    return const OtpBackupPreviewState();
  }
}

/// Represents the input data used to initialize a [OtpBackupPreviewState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class OtpBackupPreviewStateParams with _$OtpBackupPreviewStateParams {
  const factory OtpBackupPreviewStateParams() = _OtpBackupPreviewStateParams;
}
