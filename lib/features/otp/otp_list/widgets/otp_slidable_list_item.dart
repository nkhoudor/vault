import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// An [OtpListItem] that reveals a delete action when swiped towards the start.
class OtpSlidableListItem extends StatelessWidget {
  const OtpSlidableListItem({required this.otp, required this.onTap, required this.onDeletePressed, super.key});

  final OtpDisplayable otp;
  final VoidCallback onTap;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => onDeletePressed(),
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            icon: Icons.delete,
            label: context.l10n.delete,
          ),
        ],
      ),
      child: OtpListItem(otp: otp, onTap: onTap),
    );
  }
}
