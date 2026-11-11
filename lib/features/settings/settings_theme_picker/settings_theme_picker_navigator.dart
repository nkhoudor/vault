/// Defines navigation actions that the SettingsThemePicker feature can trigger.
///
/// This interface is implemented outside the feature, typically by
/// the app's navigation layer or parent coordinator.
abstract class SettingsThemePickerNavigator {
  Future<void> navigateToThemePicker();
}
