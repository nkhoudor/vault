import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_setup_step.dart';
import 'package:flutter/material.dart';

/// How to get a first code, shown while there are no accounts.
class OtpSetupSteps extends StatelessWidget {
  const OtpSetupSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.setupTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 28),
            OtpSetupStep(number: 1, title: l10n.setupStepEnable, hint: l10n.setupStepEnableHint),
            const SizedBox(height: 22),
            OtpSetupStep(number: 2, title: l10n.setupStepScan, hint: l10n.setupStepScanHint),
            const SizedBox(height: 22),
            OtpSetupStep(number: 3, title: l10n.setupStepSignIn, hint: l10n.setupStepSignInHint),
          ],
        ),
      ),
    );
  }
}
