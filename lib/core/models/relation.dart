import 'package:freezed_annotation/freezed_annotation.dart';

part 'relation.freezed.dart';

/// Crow's-foot cardinality for one end of a [Relation].
enum Cardinality {
  zeroOrOne, // ─○|   optional, at most one
  exactlyOne, // ─||   mandatory, exactly one
  zeroOrMany, // ─○<   optional, many
  oneOrMany, // ─|<   mandatory, one or more
}

/// What happens to the child rows when the referenced parent row is
/// deleted or its key updated.
enum ReferentialAction { noAction, restrict, cascade, setNull, setDefault }

/// One side of a [Relation]: the entity it attaches to and the cardinality
/// drawn at that end.
@freezed
abstract class RelationEnd with _$RelationEnd {
  const factory RelationEnd({
    required String entityId,
    required Cardinality cardinality,
  }) = _RelationEnd;
}

/// Maps one foreign-key field on the child to the field it references on the
/// parent. A relation holds several links to express a composite foreign key.
@freezed
abstract class FieldLink with _$FieldLink {
  const factory FieldLink({
    required String childFieldId,
    required String parentFieldId,
  }) = _FieldLink;
}

/// A connection between two entities. The child holds the foreign key that
/// references the parent's primary/unique key. (Model many-to-many with a
/// junction entity, as you would in a real schema.)
@freezed
abstract class Relation with _$Relation {
  const factory Relation({
    required String id,

    /// The referenced side — holds the primary/unique key.
    required RelationEnd parent,

    /// The referencing side — holds the foreign key.
    required RelationEnd child,

    /// The field pairs that make up the foreign key.
    @Default(<FieldLink>[]) List<FieldLink> links,
    @Default(ReferentialAction.noAction) ReferentialAction onDelete,
    @Default(ReferentialAction.noAction) ReferentialAction onUpdate,

    /// Identifying relationship (solid line): the FK is part of the child's
    /// primary key. Otherwise non-identifying (dashed line).
    @Default(false) bool isIdentifying,

    /// Optional verb label, e.g. "places", "belongs to".
    String? name,
  }) = _Relation;
}
