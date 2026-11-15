import 'dart:math';

import 'package:flutter/material.dart';

/// Four corner brackets that show where to hold the QR code.
class OtpScannerFrame extends StatelessWidget {
  const OtpScannerFrame({super.key});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(painter: _FramePainter(color: Theme.of(context).colorScheme.primary)),
  );
}

class _FramePainter extends CustomPainter {
  const _FramePainter({required this.color});

  final Color color;

  static const _maxSide = 240.0;
  static const _radius = 28.0;
  static const _arm = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final frame = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: min(size.shortestSide * 0.7, _maxSide),
      height: min(size.shortestSide * 0.7, _maxSide),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final corner = Path()
      ..moveTo(0, _radius + _arm)
      ..lineTo(0, _radius)
      ..arcToPoint(const Offset(_radius, 0), radius: const Radius.circular(_radius))
      ..lineTo(_radius + _arm, 0);

    for (var quarter = 0; quarter < 4; quarter++) {
      canvas
        ..save()
        ..translate(frame.center.dx, frame.center.dy)
        ..rotate(quarter * pi / 2)
        ..translate(-frame.width / 2, -frame.height / 2)
        ..drawPath(corner, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_FramePainter oldDelegate) => oldDelegate.color != color;
}
