import 'package:app_core/features/otp/otp_list/widgets/otp_code_digit.dart';
import 'package:flutter/material.dart';

/// A one-time code split into two groups, where only the digits that changed animate.
class OtpCodeText extends StatelessWidget {
  const OtpCodeText({required this.code, this.style, super.key});

  final String code;
  final TextStyle? style;

  static const _groupGap = 10.0;

  /// Codes of 6 and 8 digits are shown as two halves; other lengths stay in one group.
  int? get _groupSize => code.length == 6 || code.length == 8 ? code.length ~/ 2 : null;

  @override
  Widget build(BuildContext context) {
    // Equal-width digits keep the code from shifting sideways while it changes.
    final digitStyle = style?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    final groupSize = _groupSize;

    return Semantics(
      label: code.split('').join(' '),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (index, character) in code.split('').indexed) ...[
              if (index == groupSize) const SizedBox(width: _groupGap),
              OtpCodeDigit(character: character, style: digitStyle),
            ],
          ],
        ),
      ),
    );
  }
}
