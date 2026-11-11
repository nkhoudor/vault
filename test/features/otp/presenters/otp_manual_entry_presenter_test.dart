import 'package:app_core/features/otp/domain/model/otp_algorithm.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_presenter.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../otp_secret_matcher.dart';

void main() {
  late MockOtpManualEntryNavigator navigator;
  late MockOtpManualEntryRepository repository;
  late OtpManualEntryPresenter presenter;

  setUpAll(
    () => registerFallbackValue(
      const OtpSecret(id: '', issuer: '', secret: '', period: 30, digits: 6, algorithm: OtpAlgorithm.sha1),
    ),
  );

  setUp(() {
    navigator = MockOtpManualEntryNavigator();
    repository = MockOtpManualEntryRepository();
    when(() => navigator.navigateBack()).thenAnswer((_) async {});
    when(() => repository.addSecret(any())).thenAnswer((_) async {});
    presenter = OtpManualEntryPresenter(OtpManualEntryState.empty(), navigator, repository);
  });

  void fillValidForm() {
    presenter
      ..onIssuerChanged(' GitHub ')
      ..onAccountChanged(' alice@example.com ')
      ..onSecretKeyChanged('jbsw y3dp ehpk 3pxp');
  }

  group('state', () {
    test('an untouched form is invalid but shows no errors', () {
      expect(presenter.state.isValid, isFalse);
      expect(presenter.state.showIssuerError, isFalse);
      expect(presenter.state.showSecretKeyError, isFalse);
    });

    test('edits are kept as typed', () {
      fillValidForm();

      expect(
        presenter.state,
        const OtpManualEntryState(issuer: ' GitHub ', account: ' alice@example.com ', secretKey: 'jbsw y3dp ehpk 3pxp'),
      );
      expect(presenter.state.isValid, isTrue);
    });
  });

  group('onSavePressed', () {
    test('stores a trimmed, normalized secret with the default settings and goes back', () async {
      fillValidForm();

      await presenter.onSavePressed();

      verifyInOrder([
        () => repository.addSecret(
          any(
            that: equalsIgnoringId(
              const OtpSecret(
                id: '',
                issuer: 'GitHub',
                account: 'alice@example.com',
                secret: 'JBSWY3DPEHPK3PXP',
                period: 30,
                digits: 6,
                algorithm: OtpAlgorithm.sha1,
              ),
            ),
          ),
        ),
        () => navigator.navigateBack(),
      ]);
    });

    test('shows errors for an invalid form and stores nothing', () async {
      presenter.onSecretKeyChanged('not a key!');

      await presenter.onSavePressed();

      expect(presenter.state.showIssuerError, isTrue);
      expect(presenter.state.showSecretKeyError, isTrue);
      verifyNever(() => repository.addSecret(any()));
      verifyNever(() => navigator.navigateBack());
    });

    test('an error disappears once its field is fixed', () async {
      await presenter.onSavePressed();

      presenter.onIssuerChanged('GitHub');

      expect(presenter.state.showIssuerError, isFalse);
      expect(presenter.state.showSecretKeyError, isTrue);
    });

    test('the account is optional', () async {
      presenter
        ..onIssuerChanged('GitHub')
        ..onSecretKeyChanged('JBSWY3DPEHPK3PXP');

      await presenter.onSavePressed();

      final stored = verify(() => repository.addSecret(captureAny())).captured.single as OtpSecret;
      expect(stored.account, isEmpty);
    });

    test('reports a failed save and stays on the form', () async {
      when(() => repository.addSecret(any())).thenThrow(Exception('storage unavailable'));
      fillValidForm();

      await presenter.onSavePressed();

      expect(presenter.state.saveFailed, isTrue);
      expect(presenter.state.isSaving, isFalse);
      verifyNever(() => navigator.navigateBack());
    });

    test('logs why a save failed', () async {
      final error = Exception('storage unavailable');
      final logged = <LogEvent>[];
      void onLog(LogEvent event) => logged.add(event);
      Logger.addLogListener(onLog);
      addTearDown(() => Logger.removeLogListener(onLog));
      when(() => repository.addSecret(any())).thenThrow(error);
      fillValidForm();

      await presenter.onSavePressed();

      expect(logged.single.level, Level.error);
      expect(logged.single.error, error);
    });
  });
}
