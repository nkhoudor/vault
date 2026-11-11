import 'dart:convert';

import 'package:app_core/core/clipboard/system_clipboard.dart';
import 'package:app_core/core/storage/secure_storage.dart';
import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:app_core/features/otp/otp_list/domain/repository/otp_list_repository.dart';
import 'package:app_core/features/otp/otp_manual_entry/domain/repository/otp_manual_entry_repository.dart';
import 'package:app_core/features/otp/otp_scanner/domain/repository/otp_scanner_repository.dart';
import 'package:app_core/utils/json_decoder.dart';

const _otpSecretsKey = 'otp_secrets';

class OtpRepositoryImpl implements OtpListRepository, OtpScannerRepository, OtpManualEntryRepository {
  OtpRepositoryImpl(this._secureStorage, this._clipboard);

  final SecureStorage _secureStorage;
  final SystemClipboard _clipboard;

  @override
  Stream<Iterable<OtpSecret>> getOtpSecretsStream() {
    return _secureStorage
        .getStringStream(_otpSecretsKey)
        .map((json) => JsonDecoder().decodeIterable(json, OtpSecret.fromJson));
  }

  @override
  Future<void> copyCode(String code) => _clipboard.setText(code);

  @override
  Future<void> addSecret(OtpSecret secret) async {
    final json = await _secureStorage.getString(_otpSecretsKey);
    final existing = JsonDecoder().decodeIterable(json, OtpSecret.fromJson).toList();
    if (existing.any(secret.isDuplicateOf)) return;
    existing.add(secret);
    await _secureStorage.setString(_otpSecretsKey, jsonEncode(existing.map((s) => s.toJson()).toList()));
  }

  @override
  Future<void> removeSecret(String id) async {
    final json = await _secureStorage.getString(_otpSecretsKey);
    final existing = JsonDecoder().decodeIterable(json, OtpSecret.fromJson).toList();
    existing.removeWhere((secret) => secret.id == id);
    await _secureStorage.setString(_otpSecretsKey, jsonEncode(existing.map((s) => s.toJson()).toList()));
  }
}
