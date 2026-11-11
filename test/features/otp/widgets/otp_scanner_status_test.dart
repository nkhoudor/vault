import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/model/otp_auth_uri_exception.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
import 'package:app_core/features/otp/otp_scanner/widgets/otp_scanner_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpStatus(WidgetTester tester, OtpScannerState state) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      home: Scaffold(body: OtpScannerStatus(state: state)),
    ),
  );

  testWidgets('shows the hint while nothing has been rejected', (tester) async {
    await pumpStatus(tester, OtpScannerState.empty());

    expect(find.text('Point the camera at the QR code shown by the service.'), findsOneWidget);
  });

  testWidgets('has a distinct message for every reason a code is rejected', (tester) async {
    final messages = <String>{};
    for (final error in OtpAuthUriError.values) {
      await pumpStatus(tester, OtpScannerState(codeError: error));
      messages.add(tester.widget<Text>(find.byType(Text)).data!);
    }

    expect(messages, hasLength(OtpAuthUriError.values.length));
    expect(messages, isNot(contains('Point the camera at the QR code shown by the service.')));
  });

  testWidgets('shows no hint when the camera cannot be used', (tester) async {
    await pumpStatus(tester, const OtpScannerState(cameraIssue: OtpScannerCameraIssue.permissionDenied));

    expect(find.byType(Text), findsNothing);
  });

  testWidgets('shows progress while the code is being stored', (tester) async {
    await pumpStatus(tester, const OtpScannerState(isSaving: true));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a message when the code could not be stored', (tester) async {
    await pumpStatus(tester, const OtpScannerState(saveFailed: true));

    expect(find.text('The account could not be saved. Try again.'), findsOneWidget);
  });
}
