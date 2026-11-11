import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/otp/otp_list/otp_list_state.freezed.dart';

/// Represents the UI or business state for the "OtpList" feature.
@freezed
abstract class OtpListState with _$OtpListState {
  const factory OtpListState({required Iterable<OtpDisplayable> otpList, @Default('') String searchQuery}) =
      _OtpListState;

  const OtpListState._();

  /// Creates an initial empty [OtpListState].
  factory OtpListState.empty() {
    return const OtpListState(otpList: []);
  }

  /// Creates a [OtpListState] from initial parameters.
  // ignore: avoid_unused_constructor_parameters
  factory OtpListState.fromInitialParams(OtpListStateParams? initialParams) {
    return OtpListState.empty();
  }

  bool get isSearching => searchQuery.trim().isNotEmpty;

  /// Entries whose name or account contains [searchQuery] (case-insensitive), or all entries when the query is blank.
  List<OtpDisplayable> get visibleEntries {
    final query = searchQuery.trim().toLowerCase();
    return [
      for (final otp in otpList)
        if (query.isEmpty || otp.name.toLowerCase().contains(query) || otp.account.toLowerCase().contains(query)) otp,
    ];
  }
}

/// Represents the input data used to initialize a [OtpListState].
///
/// Typically, this is passed from the presenter or navigation layer
/// when the feature is initialized.
///
/// **Important:**
/// Include parameters in this state only if they are owned and managed by this feature.
/// Parameters controlled by a parent widget (e.g., values that depend on the parent's state)
/// should be passed through the widget's constructor instead of being part of this state.
@freezed
abstract class OtpListStateParams with _$OtpListStateParams {
  const factory OtpListStateParams() = _OtpListStateParams;
}
