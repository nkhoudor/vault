import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part '../generated/utils/lazy.freezed.dart';

@freezed
sealed class Lazy<T> with _$Lazy<T> {
  const factory Lazy.initial() = Initial;
  const factory Lazy.loading() = Loading;
  const factory Lazy.success(T value) = Success;
  const factory Lazy.error(Object error) = Error;
}

@freezed
sealed class LazyEvent with _$LazyEvent {
  const factory LazyEvent.load() = Load;
}

extension LazyExtension<T> on Stream<T> {
  Stream<Lazy<T>> toLazy() =>
      map((t) => Lazy.success(t)) //
          .handleError((error, _) => Lazy.error(error))
          .startWith(Lazy.loading());
}
