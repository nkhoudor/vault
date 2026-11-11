import 'package:app_core/features/otp/domain/model/otp_secret.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher equalsIgnoringId(OtpSecret expected) =>
    isA<OtpSecret>().having((secret) => secret.copyWith(id: expected.id), 'secret without its id', expected);
