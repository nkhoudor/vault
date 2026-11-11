import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/use_case/parse_otp_auth_uri_use_case.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_presenter.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_widget.dart';
import 'package:app_core/features/otp/otp_scanner/widgets/otp_scanner_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

/// The camera preview itself needs a device, so these tests cover the states that replace it.
void main() {
  late MockOtpScannerNavigator navigator;

  setUp(() {
    navigator = MockOtpScannerNavigator();
    when(() => navigator.navigateToOtpManualEntry()).thenAnswer((_) async {});
  });

  Future<void> pumpScanner(WidgetTester tester, OtpScannerState state) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      home: Scaffold(
        body: OtpScannerWidget(
          presenter: OtpScannerPresenter(state, navigator, MockOtpScannerRepository(), const ParseOtpAuthUriUseCase()),
        ),
      ),
    ),
  );

  testWidgets('explains a refused camera instead of showing the preview', (tester) async {
    await pumpScanner(tester, const OtpScannerState(cameraIssue: OtpScannerCameraIssue.permissionDenied));

    expect(find.byType(OtpScannerCamera), findsNothing);
    expect(find.textContaining('not allowed to use the camera'), findsOneWidget);
    expect(find.textContaining('Point the camera'), findsNothing);
  });

  testWidgets('explains an unavailable camera instead of showing the preview', (tester) async {
    await pumpScanner(tester, const OtpScannerState(cameraIssue: OtpScannerCameraIssue.unavailable));

    expect(find.byType(OtpScannerCamera), findsNothing);
    expect(find.text('The camera is not available. Enter the setup key instead.'), findsOneWidget);
  });

  testWidgets('"Enter setup key" opens manual entry', (tester) async {
    await pumpScanner(tester, const OtpScannerState(cameraIssue: OtpScannerCameraIssue.unavailable));

    await tester.tap(find.text('Enter setup key'));
    await tester.pumpAndSettle();

    verify(() => navigator.navigateToOtpManualEntry()).called(1);
  });
}
