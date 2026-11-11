import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_code_text.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_countdown_ring.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

class OtpListItem extends StatefulWidget {
  const OtpListItem({required this.otp, required this.onTap, super.key});

  final OtpDisplayable otp;
  final VoidCallback onTap;

  @override
  State<OtpListItem> createState() => _OtpListItemState();
}

class _OtpListItemState extends State<OtpListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _setupAnimation();
  }

  @override
  void didUpdateWidget(OtpListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.otp.expiresAt != widget.otp.expiresAt || oldWidget.otp.createdAt != widget.otp.createdAt) {
      _setupAnimation();
    }
  }

  void _setupAnimation() {
    final now = clock.now();
    final totalDuration = widget.otp.expiresAt.difference(widget.otp.createdAt);
    final remainingDuration = widget.otp.expiresAt.difference(now);

    if (remainingDuration.isNegative || totalDuration.inMilliseconds <= 0) {
      _controller.value = 0;
    } else {
      _controller.duration = totalDuration;
      final startValue = remainingDuration.inMilliseconds / totalDuration.inMilliseconds;
      _controller.reverse(from: startValue.clamp(0.0, 1.0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.otp.name,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.otp.account.isNotEmpty)
                      Text(
                        widget.otp.account,
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    OtpCodeText(
                      code: widget.otp.code,
                      style: textTheme.headlineLarge?.copyWith(color: colorScheme.primary, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              OtpCountdownRing(remaining: _controller),
            ],
          ),
        ),
      ),
    );
  }
}
