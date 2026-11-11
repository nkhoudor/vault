import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_navigator.dart';
import 'package:app_core/features/shared/custom_app_bar/custom_app_bar_state.dart';
import 'package:app_core/features/shared/custom_app_bar/domain/repository/custom_app_bar_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBarPresenter extends Cubit<CustomAppBarState> {
  CustomAppBarPresenter(super.model, this._navigator, this._repository);

  final CustomAppBarNavigator _navigator;
  //ignore: unused_field
  final CustomAppBarRepository _repository;

  void onSettingsTapped() => _navigator.navigateToSettings();
}
