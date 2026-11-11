import 'dart:convert';

class JsonDecoder {
  JsonDecoder();

  T decode<T>(dynamic body, T Function(Map<String, dynamic>) fromJson) {
    if (body is String) {
      final data = jsonDecode(body);
      return fromJson(data);
    } else if (body is Map<String, dynamic>) {
      return fromJson(body);
    } else {
      throw Exception('Invalid body type: $body');
    }
  }

  Iterable<T> decodeIterable<T>(dynamic body, T Function(Map<String, dynamic>) fromJson) {
    if (body == null) {
      return [];
    }
    if (body is String) {
      final data = jsonDecode(body) as Iterable;
      return data.map((e) => fromJson(e));
    } else {
      throw Exception('Invalid body type: $body');
    }
  }
}
