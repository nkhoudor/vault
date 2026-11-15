import 'dart:typed_data';

import 'package:app_core/features/otp/domain/model/otp_backup_sheet.dart';
import 'package:app_core/features/otp/domain/model/otp_backup_sheet_texts.dart';

final backupSheetTexts = OtpBackupSheetTexts(
  title: 'Authenticator backup',
  summary: (accountCount, date) => '$accountCount accounts · exported ${date.year}',
  warning: 'Keep this page private. Anyone who has it can generate your codes.',
  footer: 'Scan with any app, or type the key. Time-based, SHA1, 6 digits, 30 s unless a card says otherwise.',
  pageLabel: (page, pageCount) => 'Page $page of $pageCount',
  parametersLabel: (algorithm, digits, period) => '$algorithm · $digits digits · $period s',
);

/// A sheet of two accounts on one page, drawn as a single transparent pixel.
final backupSheet = OtpBackupSheet(
  name: 'Authenticator backup',
  accountCount: 2,
  pdf: Uint8List.fromList('%PDF-'.codeUnits),
  pages: [
    Uint8List.fromList(const [
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, //
      0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
      0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, //
      0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
    ]),
  ],
);
