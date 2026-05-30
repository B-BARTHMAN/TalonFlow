import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talonflow/core/models/field_type.dart';

part 'entity_field.freezed.dart';

/// A single column of an [Entity].
///
/// Called "field" rather than "column" to avoid clashing with Flutter's own
/// `Column` widget. Whether a field is a *foreign* key is not stored here — it
/// is derived from the [Relation]s pointing at this entity, so there is one
/// source of truth and nothing to keep in sync.
@freezed
abstract class EntityField with _$EntityField {
  const factory EntityField({
    required String id,
    required String name,
    required FieldType type,

    /// Part of the primary key. Flag several fields for a composite key.
    @Default(false) bool isPrimaryKey,
    @Default(true) bool isNullable,
    @Default(false) bool isUnique,
    @Default(false) bool isAutoIncrement,

    /// Raw SQL default expression, e.g. `now()` or `0`.
    String? defaultValue,

    /// Raw SQL CHECK expression, e.g. `price > 0`.
    String? check,
    String? comment,
  }) = _EntityField;
}
