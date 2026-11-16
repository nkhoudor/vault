import 'package:flutter/material.dart';

/// One numbered setup step: what to do and a detail about it.
class OtpSetupStep extends StatelessWidget {
  const OtpSetupStep({required this.number, required this.title, required this.hint, super.key});

  final int number;
  final String title;
  final String hint;

  static const _numberSize = 36.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _numberSize,
          height: _numberSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surfaceContainerHigh,
            border: Border.all(color: colorScheme.outlineVariant, width: 2),
          ),
          child: Text('$number', style: textTheme.titleMedium),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleMedium),
              Text(hint, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}
