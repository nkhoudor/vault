import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/otp_list/otp_list_presenter.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/features/otp/otp_list/otp_list_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../helpers/golden_test_helpers.dart';

/// Expired OTP times so the progress ring is deterministic (value 0).
final _expiredCreatedAt = DateTime(2020, 1, 1, 12, 0, 0);
final _expiredExpiresAt = DateTime(2020, 1, 1, 11, 0, 0);

final _items = [
  OtpDisplayable(
    id: 'service',
    name: 'Service',
    account: 'user@example.com',
    code: '123456',
    createdAt: _expiredCreatedAt,
    expiresAt: _expiredExpiresAt,
  ),
  OtpDisplayable(
    id: 'other',
    name: 'Other',
    code: '987654',
    createdAt: _expiredCreatedAt,
    expiresAt: _expiredExpiresAt,
  ),
];

void main() {
  goldenTest(
    'otp_list_empty',
    builder: () {
      final watchOtpList = MockWatchOtpListUseCase();
      when(() => watchOtpList()).thenAnswer((_) => Stream.value([]));
      return OtpListWidget(
        presenter: OtpListPresenter(
          OtpListState.empty(),
          MockOtpListNavigator(),
          MockOtpListRepository(),
          watchOtpList,
        ),
      );
    },
  );

  goldenTest(
    'otp_list_with_items',
    builder: () {
      final watchOtpList = MockWatchOtpListUseCase();
      when(() => watchOtpList()).thenAnswer((_) => Stream.value(_items));
      return OtpListWidget(
        presenter: OtpListPresenter(
          OtpListState(otpList: _items),
          MockOtpListNavigator(),
          MockOtpListRepository(),
          watchOtpList,
        ),
      );
    },
  );

  goldenTest(
    'otp_list_no_matches',
    builder: () {
      final watchOtpList = MockWatchOtpListUseCase();
      when(() => watchOtpList()).thenAnswer((_) => Stream.value(_items));
      return OtpListWidget(
        presenter: OtpListPresenter(
          OtpListState(otpList: _items, searchQuery: 'github'),
          MockOtpListNavigator(),
          MockOtpListRepository(),
          watchOtpList,
        ),
      );
    },
  );
}
