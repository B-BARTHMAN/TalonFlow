import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talonflow/core/models/entity_field.dart';

part 'entity.freezed.dart';

/// A table, drawn as a node on the diagram canvas.
@freezed
abstract class Entity with _$Entity {
  const factory Entity({
    required String id,
    required String name,

    /// Canvas position of the node's top-left corner.
    @Default(0.0) double x,
    @Default(0.0) double y,

    /// Fields in display order.
    @Default(<EntityField>[]) List<EntityField> fields,
    String? comment,
  }) = _Entity;
}
