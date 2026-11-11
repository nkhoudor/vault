import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/utils/selectable.freezed.dart';

@freezed
sealed class Selectable<T> with _$Selectable<T> {
  const factory Selectable.selected(T item) = Selected;
  const factory Selectable.deselected(T item) = Deselected;

  factory Selectable.toSelectable(T item, bool isSelected) =>
      isSelected ? Selectable.selected(item) : Selectable.deselected(item);
}
