import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/domain/use_case/watch_otp_list_use_case.dart';
import 'package:app_core/features/otp/otp_list/domain/repository/otp_list_repository.dart';
import 'package:app_core/features/otp/otp_list/otp_list_navigator.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpListPresenter extends Cubit<OtpListState> with SubscriptionsMixin {
  OtpListPresenter(super.model, this._navigator, this._repository, this._watchOtpListUseCase) {
    listenTo(
      stream: _watchOtpListUseCase(),
      subscriptionId: _otpListStreamSubscription,
      onChange: (otpList) =>
          tryEmit(state.copyWith(otpList: otpList, searchQuery: otpList.isEmpty ? '' : state.searchQuery)),
    );
  }

  //ignore: unused_field
  final OtpListNavigator _navigator;
  final OtpListRepository _repository;
  final WatchOtpListUseCase _watchOtpListUseCase;

  static const _otpListStreamSubscription = 'otpListStreamSubscription';

  void onSearchChanged(String query) => tryEmit(state.copyWith(searchQuery: query));

  Future<void> onCodeTapped(OtpDisplayable otp) => _repository.copyCode(otp.code);

  Future<void> onDeleteConfirmed(OtpDisplayable otp) => _repository.removeSecret(otp.id);
}
