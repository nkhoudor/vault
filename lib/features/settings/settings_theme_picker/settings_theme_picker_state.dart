import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/settings/settings_theme_picker/settings_theme_picker_state.freezed.dart';

/// Represents the UI or business state for the "SettingsThemePicker" feature.
@freezed
abstract class SettingsThemePickerState with _$SettingsThemePickerState {
  const factory SettingsThemePickerState() = _SettingsThemePickerState;

  /// Creates an initial empty [SettingsThemePickerState].
  factory SettingsThemePickerState.empty() {
    return const SettingsThemePickerState();
  }

  /// Creates a [SettingsThemePickerState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory SettingsThemePickerState.fromInitialParams(SettingsThemePickerStateParams? initialParams) {
    return SettingsThemePickerState.empty();
  }
}

/// Represents the input data used to initialize a [SettingsThemePickerState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class SettingsThemePickerStateParams with _$SettingsThemePickerStateParams {
  const factory SettingsThemePickerStateParams() = _SettingsThemePickerStateParams;
}
