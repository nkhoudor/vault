import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_presenter.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_state.dart';
import 'package:app_core/features/otp/otp_manual_entry/otp_manual_entry_widget.dart';

import '../../../mocks.dart';
import '../../helpers/golden_test_helpers.dart';

void main() {
  OtpManualEntryWidget build(OtpManualEntryState state) => OtpManualEntryWidget(
    presenter: OtpManualEntryPresenter(state, MockOtpManualEntryNavigator(), MockOtpManualEntryRepository()),
  );

  goldenTest('otp_manual_entry_empty', builder: () => build(OtpManualEntryState.empty()));

  goldenTest('otp_manual_entry_errors', builder: () => build(const OtpManualEntryState(showErrors: true)));
}
