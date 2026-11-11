import 'package:app_core/features/otp/domain/model/otp_auth_uri_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/otp/otp_scanner/otp_scanner_state.freezed.dart';

/// Represents the UI or business state for the "OtpScanner" feature.
@freezed
abstract class OtpScannerState with _$OtpScannerState {
  const factory OtpScannerState({
    /// Why the camera cannot be used; null while it works or is still starting.
    OtpScannerCameraIssue? cameraIssue,

    /// Why the last scanned code was rejected; null while nothing has been rejected.
    OtpAuthUriError? codeError,

    /// True from the moment a valid code is accepted until the screen closes.
    @Default(false) bool isSaving,

    /// True when a valid code could not be stored.
    @Default(false) bool saveFailed,
  }) = _OtpScannerState;

  /// Creates an initial empty [OtpScannerState].
  factory OtpScannerState.empty() {
    return const OtpScannerState();
  }

  /// Creates a [OtpScannerState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory OtpScannerState.fromInitialParams(OtpScannerStateParams? initialParams) {
    return OtpScannerState.empty();
  }
}

/// Why the scanner has no camera picture to read codes from.
enum OtpScannerCameraIssue { permissionDenied, unavailable }

/// Represents the input data used to initialize a [OtpScannerState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class OtpScannerStateParams with _$OtpScannerStateParams {
  const factory OtpScannerStateParams() = _OtpScannerStateParams;
}
