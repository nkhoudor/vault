import 'dart:async';

import 'package:app_core/core/logs.dart';
import 'package:app_core/di/app_feature_component.dart';
import 'package:app_core/features/otp/di/feature_component.dart';
import 'package:app_core/features/settings/di/feature_component.dart';
import 'package:app_core/features/shared/di/feature_component.dart';
import 'package:app_core/features/theme/di/feature_component.dart';
import 'package:get_it/get_it.dart';
//DO-NOT-REMOVE APP_COMPONENT_IMPORTS

//ignore: non_constant_identifier_names
final DI = AppComponent._([
  ThemeFeatureComponent(),
  SharedFeatureComponent(),
  OtpFeatureComponent(),
  SettingsFeatureComponent(),
  //DO-NOT-REMOVE FEATURE_COMPONENT_INIT
]);

abstract class FeatureComponent {
  Future<void> configureDependencies({required AppComponent appComponent});
}

class AppComponent {
  AppComponent._(this._featureComponents);

  final List<FeatureComponent> _featureComponents;
  final _di = GetIt.I;
  static Completer? _initCompleter;

  Future<void> configureDependencies() async {
    if (_initCompleter != null) {
      Logs.w(_initCompleter!.isCompleted ? 'DI has already been initialized' : 'DI is already initializing');
      return _initCompleter!.future;
    }

    _initCompleter = Completer();

    for (final featureComponent in _featureComponents) {
      await featureComponent.configureDependencies(appComponent: this);
    }

    _di.pushNewScope();
    await AppFeatureComponent().configureDependencies(appComponent: this);

    _initCompleter?.complete(true);
  }

  T get<T extends Object>({dynamic param1, dynamic param2, String? instanceName, Type? type}) {
    return _di.get<T>(param1: param1, param2: param2, instanceName: instanceName, type: type);
  }

  void registerFactory<T extends Object>(FactoryFunc<T> factoryFunc, {String? instanceName}) {
    _di.registerFactory<T>(factoryFunc, instanceName: instanceName);
  }

  void registerCachedFactory<T extends Object>(FactoryFunc<T> factoryFunc, {String? instanceName}) {
    _di.registerCachedFactory<T>(factoryFunc, instanceName: instanceName);
  }

  void registerFactoryParam<T extends Object, P1, P2>(FactoryFuncParam<T, P1, P2> factoryFunc, {String? instanceName}) {
    _di.registerFactoryParam<T, P1, P2>(factoryFunc, instanceName: instanceName);
  }

  void registerCachedFactoryParam<T extends Object, P1, P2>(
    FactoryFuncParam<T, P1, P2> factoryFunc, {
    String? instanceName,
  }) {
    _di.registerCachedFactoryParam<T, P1, P2>(factoryFunc, instanceName: instanceName);
  }

  T registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    return _di.registerSingleton<T>(instance, instanceName: instanceName, signalsReady: signalsReady, dispose: dispose);
  }

  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
    bool useWeakReference = false,
  }) {
    _di.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
      dispose: dispose,
      useWeakReference: useWeakReference,
    );
  }
}
