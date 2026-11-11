import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/otp/otp_add_button/otp_add_button_state.freezed.dart';

/// Represents the UI or business state for the "OtpAddButton" feature.
@freezed
abstract class OtpAddButtonState with _$OtpAddButtonState {
  const factory OtpAddButtonState() = _OtpAddButtonState;

  /// Creates a [OtpAddButtonState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory OtpAddButtonState.fromInitialParams(OtpAddButtonStateParams? initialParams) {
    return const OtpAddButtonState();
  }
}

/// Represents the input data used to initialize a [OtpAddButtonState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class OtpAddButtonStateParams with _$OtpAddButtonStateParams {
  const factory OtpAddButtonStateParams() = _OtpAddButtonStateParams;
}
