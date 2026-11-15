import 'package:flutter/material.dart';

/// A ring that empties as a code runs out and changes color shortly before the end.
class OtpCountdownRing extends StatelessWidget {
  const OtpCountdownRing({required this.remaining, required this.lightUp, super.key});

  /// Share of the code's lifetime that is left, from 1 down to 0.
  final Animation<double> remaining;

  /// How lit the whole ring is, from 0 (the color of its track) to 1 (its own color).
  final Animation<double> lightUp;

  static const _strokeWidth = 12.0;
  static const _turningBelow = 0.2;
  static const _expiringBelow = 0.1;

  /// The primary color, blending into the error color between the last fifth and the last tenth of the lifetime.
  static Color colorFor(double remaining, ColorScheme colorScheme) => Color.lerp(
    colorScheme.primary,
    colorScheme.error,
    ((_turningBelow - remaining) / (_turningBelow - _expiringBelow)).clamp(0.0, 1.0),
  )!;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(_strokeWidth / 2),
      child: AnimatedBuilder(
        animation: Listenable.merge([remaining, lightUp]),
        builder: (context, child) => CircularProgressIndicator(
          value: remaining.value,
          strokeWidth: _strokeWidth,
          backgroundColor: colorScheme.surfaceContainerHigh,
          color: Color.lerp(colorScheme.surfaceContainerHigh, colorFor(remaining.value, colorScheme), lightUp.value),
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
