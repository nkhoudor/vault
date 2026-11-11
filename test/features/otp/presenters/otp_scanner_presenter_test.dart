import 'dart:async';

import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_auth_uri_exception.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/domain/use_case/parse_otp_auth_uri_use_case.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_presenter.dart';
import 'package:app_core/features/otp/otp_scanner/otp_scanner_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../otp_secret_matcher.dart';

const _validCode = 'otpauth://totp/GitHub:alice?secret=JBSWY3DPEHPK3PXP&issuer=GitHub';
const _secret = OtpSecret(
  id: '',
  issuer: 'GitHub',
  account: 'alice',
  secret: 'JBSWY3DPEHPK3PXP',
  period: 30,
  digits: 6,
  algorithm: OtpAlgorithm.sha1,
);

void main() {
  late MockOtpScannerNavigator navigator;
  late MockOtpScannerRepository repository;
  late OtpScannerPresenter presenter;

  setUpAll(() => registerFallbackValue(_secret));

  setUp(() {
    navigator = MockOtpScannerNavigator();
    repository = MockOtpScannerRepository();
    when(() => navigator.navigateBack()).thenAnswer((_) async {});
    when(() => navigator.navigateToOtpManualEntry()).thenAnswer((_) async {});
    when(() => repository.addSecret(any())).thenAnswer((_) async {});
    presenter = OtpScannerPresenter(OtpScannerState.empty(), navigator, repository, const ParseOtpAuthUriUseCase());
  });

  group('onCodeDetected', () {
    test('stores a valid code and then goes back', () async {
      await presenter.onCodeDetected(_validCode);

      verifyInOrder([() => repository.addSecret(any(that: equalsIgnoringId(_secret))), () => navigator.navigateBack()]);
      expect(presenter.state, const OtpScannerState(isSaving: true));
    });

    test('reports why a code was rejected and stores nothing', () async {
      await presenter.onCodeDetected('https://example.com');

      expect(presenter.state, const OtpScannerState(codeError: OtpAuthUriError.notOtpAuth));
      verifyNever(() => repository.addSecret(any()));
      verifyNever(() => navigator.navigateBack());
    });

    test('accepts a valid code after a rejected one and clears the error', () async {
      await presenter.onCodeDetected('otpauth://hotp/a?secret=JBSWY3DPEHPK3PXP');
      expect(presenter.state.codeError, OtpAuthUriError.unsupportedType);

      await presenter.onCodeDetected(_validCode);

      expect(presenter.state, const OtpScannerState(isSaving: true));
      verify(() => repository.addSecret(any(that: equalsIgnoringId(_secret)))).called(1);
    });

    test('ignores the repeated detections of a code that is being stored', () async {
      final saving = Completer<void>();
      when(() => repository.addSecret(any())).thenAnswer((_) => saving.future);

      final first = presenter.onCodeDetected(_validCode);
      await presenter.onCodeDetected(_validCode);
      await presenter.onCodeDetected('https://example.com');
      saving.complete();
      await first;

      verify(() => repository.addSecret(any())).called(1);
      verify(() => navigator.navigateBack()).called(1);
      expect(presenter.state.codeError, isNull);
    });

    test('reports a failed save and lets the user scan again', () async {
      when(() => repository.addSecret(any())).thenThrow(Exception('storage unavailable'));

      await presenter.onCodeDetected(_validCode);

      expect(presenter.state, const OtpScannerState(saveFailed: true));
      verifyNever(() => navigator.navigateBack());

      when(() => repository.addSecret(any())).thenAnswer((_) async {});
      await presenter.onCodeDetected(_validCode);

      verify(() => navigator.navigateBack()).called(1);
    });

    test('logs why a save failed', () async {
      final error = Exception('storage unavailable');
      final logged = <LogEvent>[];
      void onLog(LogEvent event) => logged.add(event);
      Logger.addLogListener(onLog);
      addTearDown(() => Logger.removeLogListener(onLog));
      when(() => repository.addSecret(any())).thenThrow(error);

      await presenter.onCodeDetected(_validCode);

      expect(logged.single.level, Level.error);
      expect(logged.single.error, error);
    });
  });

  group('onCameraFailed', () {
    test('records that access to the camera was refused', () {
      presenter.onCameraFailed(isPermissionDenied: true);

      expect(presenter.state, const OtpScannerState(cameraIssue: OtpScannerCameraIssue.permissionDenied));
    });

    test('records any other failure as an unavailable camera', () {
      presenter.onCameraFailed(isPermissionDenied: false);

      expect(presenter.state, const OtpScannerState(cameraIssue: OtpScannerCameraIssue.unavailable));
    });
  });

  test('onEnterManuallyPressed opens manual entry', () async {
    await presenter.onEnterManuallyPressed();

    verify(() => navigator.navigateToOtpManualEntry()).called(1);
  });
}
