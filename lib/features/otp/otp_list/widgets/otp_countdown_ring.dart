import 'package:flutter/material.dart';

/// A ring that empties as a code runs out, turning from green through orange to red.
class OtpCountdownRing extends StatelessWidget {
  const OtpCountdownRing({required this.remaining, super.key});

  /// Share of the code's lifetime that is left, from 1 down to 0.
  final Animation<double> remaining;

  static const _size = 24.0;
  static const _greenUntil = 0.5;
  static const _orangeAt = 0.25;
  static const _redFrom = 0.1;

  static Color colorFor(double remaining) {
    if (remaining >= _greenUntil) return Colors.green;
    if (remaining >= _orangeAt) {
      return Color.lerp(Colors.orange, Colors.green, (remaining - _orangeAt) / (_greenUntil - _orangeAt))!;
    }
    if (remaining >= _redFrom) {
      return Color.lerp(Colors.red, Colors.orange, (remaining - _redFrom) / (_orangeAt - _redFrom))!;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return SizedBox.square(
      dimension: _size,
      child: AnimatedBuilder(
        animation: remaining,
        builder: (context, child) => CircularProgressIndicator(
          value: remaining.value,
          strokeWidth: 3,
          backgroundColor: backgroundColor,
          color: colorFor(remaining.value),
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
