import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/shared/custom_app_bar/custom_app_bar_state.freezed.dart';

/// Represents the UI or business state for the "CustomAppBar" feature.
@freezed
abstract class CustomAppBarState with _$CustomAppBarState {
  const factory CustomAppBarState() = _CustomAppBarState;

  /// Creates an initial empty [CustomAppBarState].
  factory CustomAppBarState.empty() {
    return const CustomAppBarState();
  }

  /// Creates a [CustomAppBarState] from initial parameters.
  factory CustomAppBarState.fromInitialParams(CustomAppBarStateParams? initialParams) {
    return initialParams == null ? CustomAppBarState.empty() : const CustomAppBarState();
  }
}

/// Represents the input data used to initialize a [CustomAppBarState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class CustomAppBarStateParams with _$CustomAppBarStateParams {
  const factory CustomAppBarStateParams() = _CustomAppBarStateParams;
}
