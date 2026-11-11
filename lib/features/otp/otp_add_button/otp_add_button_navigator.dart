/// Defines navigation actions that the OtpAddButton feature can trigger.
///
/// This interface is implemented outside the feature, typically by
/// the app's navigation layer or parent coordinator.
abstract class OtpAddButtonNavigator {
  Future<void> navigateToOtpScanner();
  Future<void> navigateToOtpManualEntry();
}
