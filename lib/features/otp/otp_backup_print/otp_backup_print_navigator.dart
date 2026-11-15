/// Defines navigation actions that the OtpBackupPrint feature can trigger.
///
/// This interface is implemented outside the feature, typically by
/// the app's navigation layer or parent coordinator.
abstract class OtpBackupPrintNavigator {
  Future<void> navigateToOtpBackupPreview();
}
