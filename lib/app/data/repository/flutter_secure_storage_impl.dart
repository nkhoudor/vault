import 'dart:async';

import 'package:app_core/core/storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [SecureStorage] implementation backed by [FlutterSecureStorage].
class FlutterSecureStorageImpl implements SecureStorage {
  FlutterSecureStorageImpl();

  late final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> getString(String key) => _storage.read(key: key);

  @override
  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Stream<String?> getStringStream(String key) {
    late StreamController<String?> controller;
    late void Function(dynamic) listener;

    controller = StreamController<String?>.broadcast(
      onListen: () async {
        listener = (value) => controller.add(value as String?);

        _storage.registerListener(key: key, listener: listener);

        final value = await _storage.read(key: key);
        controller.add(value);
      },
      onCancel: () {
        _storage.unregisterListener(key: key, listener: listener);
        controller.close();
      },
    );

    return controller.stream;
  }
}
