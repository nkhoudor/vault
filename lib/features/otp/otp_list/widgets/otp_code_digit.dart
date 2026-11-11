import 'package:app_core/utils/durations.dart';
import 'package:app_core/utils/motion.dart';
import 'package:flutter/material.dart';

/// One character of a code. When [character] changes, the old one rolls up and out
/// and the new one rolls in from below, like a counter.
class OtpCodeDigit extends StatelessWidget {
  const OtpCodeDigit({required this.character, this.style, super.key});

  final String character;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final currentKey = ValueKey(character);

    return ClipRect(
      child: AnimatedSwitcher(
        duration: context.motionDuration(const MediumDuration()),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          // The outgoing child runs the same animation backwards, so it needs the opposite direction.
          final begin = child.key == currentKey ? const Offset(0, 1) : const Offset(0, -1);

          return SlideTransition(
            position: Tween(begin: begin, end: Offset.zero).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Text(character, key: currentKey, style: style),
      ),
    );
  }
}
