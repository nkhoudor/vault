import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/theme/theme_builder/theme_builder_state.freezed.dart';

/// Represents the UI or business state for the "ThemeBuilder" feature.
@freezed
abstract class ThemeBuilderState with _$ThemeBuilderState {
  const factory ThemeBuilderState({required AppTheme appTheme, required AppThemeMode themeMode}) = _ThemeBuilderState;

  /// Creates an initial empty [ThemeBuilderState].
  factory ThemeBuilderState.empty() {
    return const ThemeBuilderState(appTheme: AppTheme.defaultTheme, themeMode: AppThemeMode.system);
  }

  /// Creates a [ThemeBuilderState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory ThemeBuilderState.fromInitialParams(ThemeBuilderStateParams? initialParams) {
    return ThemeBuilderState.empty();
  }
}

/// Represents the input data used to initialize a [ThemeBuilderState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent’s state)
/// should be passed through the widget’s constructor instead of being part of this state.
@freezed
abstract class ThemeBuilderStateParams with _$ThemeBuilderStateParams {
  const factory ThemeBuilderStateParams() = _ThemeBuilderStateParams;
}
