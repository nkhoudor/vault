import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:flutter/material.dart';

/// A round button with the initial of an account and its name underneath.
class OtpAccountChip extends StatelessWidget {
  const OtpAccountChip({
    required this.otp,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final OtpDisplayable otp;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  static const _size = 52.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: otp.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _size,
                height: _size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHigh,
                  border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant, width: 2),
                ),
                child: Text(
                  otp.name.characters.first.toUpperCase(),
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                otp.name,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
