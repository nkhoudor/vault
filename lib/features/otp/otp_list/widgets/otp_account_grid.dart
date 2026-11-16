import 'dart:math';

import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_account_chip.dart';
import 'package:flutter/material.dart';

/// The accounts as round buttons, in as many columns as the width and their number call for.
class OtpAccountGrid extends StatelessWidget {
  const OtpAccountGrid({
    required this.entries,
    required this.selectedId,
    required this.onSelected,
    required this.onLongPressed,
    super.key,
  });

  final List<OtpDisplayable> entries;
  final String selectedId;
  final ValueChanged<OtpDisplayable> onSelected;
  final ValueChanged<OtpDisplayable> onLongPressed;

  static const _minColumns = 4;
  static const _maxColumns = 6;
  static const _minCellWidth = 64.0;
  static const _maxCellWidth = 80.0;

  /// Between 4 and 6 columns fit, depending on [width]. Fewer accounts than that take one row,
  /// and more are spread evenly over the rows they need, so 8 accounts become 4 and 4 instead of 5 and 3.
  static int columnsFor({required double width, required int count}) {
    final fitting = (width ~/ _minCellWidth).clamp(_minColumns, _maxColumns);
    if (count <= fitting) return max(count, 1);
    final rows = (count / fitting).ceil();
    return (count / rows).ceil();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = columnsFor(width: constraints.maxWidth, count: entries.length);
      final cellWidth = min(constraints.maxWidth / columns, _maxCellWidth);

      return Center(
        child: SizedBox(
          width: columns * cellWidth,
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 12,
            children: [
              for (final otp in entries)
                SizedBox(
                  key: ValueKey(otp.id),
                  width: cellWidth,
                  child: OtpAccountChip(
                    otp: otp,
                    isSelected: otp.id == selectedId,
                    onTap: () => onSelected(otp),
                    onLongPress: () => onLongPressed(otp),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
