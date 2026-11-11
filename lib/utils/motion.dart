import 'package:flutter/widgets.dart';

extension MotionContext on BuildContext {
  /// [duration], or no time at all when the user asked the system to reduce motion.
  Duration motionDuration(Duration duration) => MediaQuery.disableAnimationsOf(this) ? Duration.zero : duration;
}
