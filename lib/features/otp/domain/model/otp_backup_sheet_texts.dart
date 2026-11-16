/// The words printed on a backup sheet, already in the user's language.
class OtpBackupSheetTexts {
  const OtpBackupSheetTexts({
    required this.title,
    required this.summary,
    required this.warning,
    required this.footer,
    required this.pageLabel,
    required this.parametersLabel,
  });

  final String title;

  /// How many accounts the sheet holds and when it was made.
  final String Function(int accountCount, DateTime date) summary;
  final String warning;
  final String footer;
  final String Function(int page, int pageCount) pageLabel;

  /// Describes the settings of an account that does not use the usual ones.
  final String Function(String algorithm, int digits, int period) parametersLabel;
}
