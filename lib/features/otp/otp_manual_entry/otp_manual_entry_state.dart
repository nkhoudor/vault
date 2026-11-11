import 'package:app_core/features/otp/domain/model/otp_secret_key.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/otp/otp_manual_entry/otp_manual_entry_state.freezed.dart';

/// Represents the UI or business state for the "OtpManualEntry" feature.
@freezed
abstract class OtpManualEntryState with _$OtpManualEntryState {
  const factory OtpManualEntryState({
    @Default('') String issuer,
    @Default('') String account,
    @Default('') String secretKey,

    /// False until the user first tries to save, so an untouched form shows no errors.
    @Default(false) bool showErrors,
    @Default(false) bool isSaving,

    /// True when a valid form could not be stored.
    @Default(false) bool saveFailed,
  }) = _OtpManualEntryState;

  const OtpManualEntryState._();

  /// Creates an initial empty [OtpManualEntryState].
  factory OtpManualEntryState.empty() {
    return const OtpManualEntryState();
  }

  /// Creates a [OtpManualEntryState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory OtpManualEntryState.fromInitialParams(OtpManualEntryStateParams? initialParams) {
    return OtpManualEntryState.empty();
  }

  bool get isIssuerValid => issuer.trim().isNotEmpty;

  bool get isSecretKeyValid => OtpSecretKey.isValid(secretKey);

  bool get isValid => isIssuerValid && isSecretKeyValid;

  bool get showIssuerError => showErrors && !isIssuerValid;

  bool get showSecretKeyError => showErrors && !isSecretKeyValid;
}

/// Represents the input data used to initialize a [OtpManualEntryState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class OtpManualEntryStateParams with _$OtpManualEntryStateParams {
  const factory OtpManualEntryStateParams() = _OtpManualEntryStateParams;
}
