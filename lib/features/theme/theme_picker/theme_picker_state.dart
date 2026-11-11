import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/utils/selectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/theme/theme_picker/theme_picker_state.freezed.dart';

/// Represents the UI or business state for the "ThemePicker" feature.
@freezed
abstract class ThemePickerState with _$ThemePickerState {
  const factory ThemePickerState({required Iterable<Selectable<AppTheme>> themes}) = _ThemePickerState;

  /// Creates an initial empty [ThemePickerState].
  factory ThemePickerState.empty() {
    return const ThemePickerState(themes: []);
  }

  /// Creates a [ThemePickerState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory ThemePickerState.fromInitialParams(ThemePickerStateParams? initialParams) {
    return ThemePickerState.empty();
  }
}

/// Represents the input data used to initialize a [ThemePickerState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class ThemePickerStateParams with _$ThemePickerStateParams {
  const factory ThemePickerStateParams() = _ThemePickerStateParams;
}
