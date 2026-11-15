import 'dart:typed_data';

import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:flutter/material.dart';

/// The pages of a backup sheet, one at a time, in the shape of an A4 page.
///
/// [pages] is null while the sheet is being laid out, or for good when that [failed].
class OtpBackupPages extends StatelessWidget {
  const OtpBackupPages({required this.pages, required this.failed, super.key});

  final List<Uint8List>? pages;
  final bool failed;

  static const _a4AspectRatio = 210 / 297;

  @override
  Widget build(BuildContext context) {
    final pages = this.pages;

    return AspectRatio(
      aspectRatio: _a4AspectRatio,
      child: pages == null
          ? Center(
              child: failed
                  ? Text(context.l10n.backupPreviewFailed, textAlign: TextAlign.center)
                  : const CircularProgressIndicator(),
            )
          : PageView(
              children: [
                for (final page in pages)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColoredBox(
                      color: Colors.white,
                      child: Image.memory(page, fit: BoxFit.contain),
                    ),
                  ),
              ],
            ),
    );
  }
}
