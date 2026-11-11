/// Defines navigation actions that the OtpManualEntry feature can trigger.
///
/// This interface is implemented outside the feature, typically by
/// the app's navigation layer or parent coordinator.
abstract class OtpManualEntryNavigator {
  Future<void> navigateBack();
}
