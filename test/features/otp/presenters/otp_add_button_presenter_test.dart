import 'package:app_core/features/otp/otp_add_button/otp_add_button_presenter.dart';
import 'package:app_core/features/otp/otp_add_button/otp_add_button_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late MockOtpAddButtonNavigator navigator;
  late OtpAddButtonPresenter presenter;

  setUp(() {
    navigator = MockOtpAddButtonNavigator();
    when(() => navigator.navigateToOtpScanner()).thenAnswer((_) async {});
    when(() => navigator.navigateToOtpManualEntry()).thenAnswer((_) async {});
    presenter = OtpAddButtonPresenter(const OtpAddButtonState(), navigator);
  });

  test('onScanQrCodeTapped opens the scanner', () async {
    await presenter.onScanQrCodeTapped();

    verify(() => navigator.navigateToOtpScanner()).called(1);
    verifyNever(() => navigator.navigateToOtpManualEntry());
  });

  test('onEnterManuallyTapped opens manual entry', () async {
    await presenter.onEnterManuallyTapped();

    verify(() => navigator.navigateToOtpManualEntry()).called(1);
    verifyNever(() => navigator.navigateToOtpScanner());
  });
}
