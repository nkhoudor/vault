import 'package:app_core/utils/motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;

/// Builds what follows the search field in [OtpListFooter]. [expansion] is 0 while it shares the row
/// with the search field and 1 once it has the row to itself.
typedef OtpListTrailingBuilder = Widget Function(BuildContext context, double expansion);

/// The search field with a trailing widget after it. While [showSearch] is off the search field
/// folds away and the trailing widget takes the whole row.
class OtpListFooter extends StatelessWidget {
  const OtpListFooter({required this.showSearch, required this.search, this.trailingBuilder, super.key});

  final bool showSearch;
  final Widget search;
  final OtpListTrailingBuilder? trailingBuilder;

  static const _duration = Duration(milliseconds: 300);
  static const _trailingSize = 52.0;
  static const _gap = 12.0;

  @override
  Widget build(BuildContext context) {
    final trailingBuilder = this.trailingBuilder;

    return TweenAnimationBuilder<double>(
      tween: Tween(end: showSearch ? 0 : 1),
      duration: context.motionDuration(_duration),
      curve: Curves.easeInOutCubic,
      builder: (context, expansion, _) => LayoutBuilder(
        builder: (context, constraints) {
          final searchWidth = trailingBuilder == null
              ? constraints.maxWidth
              : constraints.maxWidth - _trailingSize - _gap;

          return Row(
            children: [
              if (expansion < 1)
                SizedBox(
                  width: searchWidth * (1 - expansion),
                  child: Opacity(
                    opacity: 1 - expansion,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(_trailingSize / 2)),
                      child: OverflowBox(
                        alignment: AlignmentDirectional.centerStart,
                        minWidth: searchWidth,
                        maxWidth: searchWidth,
                        fit: OverflowBoxFit.deferToChild,
                        child: search,
                      ),
                    ),
                  ),
                ),
              if (trailingBuilder != null) ...[
                SizedBox(width: _gap * (1 - expansion)),
                Expanded(child: trailingBuilder(context, expansion)),
              ],
            ],
          );
        },
      ),
    );
  }
}
