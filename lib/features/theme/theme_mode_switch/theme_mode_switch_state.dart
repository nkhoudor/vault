import 'package:app_core/features/theme/domain/model/app_theme_mode.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/theme/theme_mode_switch/theme_mode_switch_state.freezed.dart';

/// Represents the UI or business state for the "ThemeModeSwitch" feature.
@freezed
abstract class ThemeModeSwitchState with _$ThemeModeSwitchState {
  const factory ThemeModeSwitchState({required AppThemeMode themeMode}) = _ThemeModeSwitchState;

  /// Creates an initial empty [ThemeModeSwitchState].
  factory ThemeModeSwitchState.empty() {
    return const ThemeModeSwitchState(themeMode: AppThemeMode.system);
  }

  /// Creates a [ThemeModeSwitchState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory ThemeModeSwitchState.fromInitialParams(ThemeModeSwitchStateParams? initialParams) {
    return ThemeModeSwitchState.empty();
  }
}

/// Represents the input data used to initialize a [ThemeModeSwitchState].
@freezed
abstract class ThemeModeSwitchStateParams with _$ThemeModeSwitchStateParams {
  const factory ThemeModeSwitchStateParams() = _ThemeModeSwitchStateParams;
}
