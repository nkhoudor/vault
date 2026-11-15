import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_code_text.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_countdown_ring.dart';
import 'package:app_core/utils/motion.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

/// The code of one account inside a ring that counts down its lifetime. Tapping it calls [onTap].
class OtpDial extends StatefulWidget {
  const OtpDial({required this.otp, required this.onTap, super.key});

  final OtpDisplayable otp;
  final VoidCallback onTap;

  @override
  State<OtpDial> createState() => _OtpDialState();
}

class _OtpDialState extends State<OtpDial> with TickerProviderStateMixin {
  late final AnimationController _remaining = AnimationController(vsync: this);
  late final AnimationController _lightUp = AnimationController(vsync: this, value: 1);

  static const _size = 300.0;
  static const _lightUpDuration = Duration(milliseconds: 300);

  Duration get _lifetime => widget.otp.expiresAt.difference(widget.otp.createdAt);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didUpdateWidget(OtpDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.otp.expiresAt != widget.otp.expiresAt || oldWidget.otp.createdAt != widget.otp.createdAt) {
      _startCountdown();
      if (oldWidget.otp.id == widget.otp.id) {
        _lightUp
          ..duration = context.motionDuration(_lightUpDuration)
          ..forward(from: 0);
      }
    }
  }

  void _startCountdown() {
    final left = widget.otp.expiresAt.difference(clock.now());

    if (left.isNegative || _lifetime.inMilliseconds <= 0) {
      _remaining.value = 0;
    } else {
      _remaining.duration = _lifetime;
      _remaining.reverse(from: (left.inMilliseconds / _lifetime.inMilliseconds).clamp(0.0, 1.0));
    }
  }

  @override
  void dispose() {
    _remaining.dispose();
    _lightUp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final otp = widget.otp;

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _size, maxHeight: _size),
          child: AspectRatio(
            aspectRatio: 1,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: widget.onTap,
                customBorder: const CircleBorder(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: OtpCountdownRing(remaining: _remaining, lightUp: _lightUp),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(otp.name, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: OtpCodeText(
                              code: otp.code,
                              style: textTheme.displaySmall?.copyWith(fontSize: 46, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            context.l10n.tapToCopy,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (otp.account.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            otp.account,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
