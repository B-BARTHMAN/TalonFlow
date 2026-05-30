import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/core/models/relation.dart';

part 'diagram.freezed.dart';

/// A single ER diagram — the whole graph the editor loads, edits and saves.
@freezed
abstract class Diagram with _$Diagram {
  const factory Diagram({
    required String id,
    required String name,
    @Default(<Entity>[]) List<Entity> entities,
    @Default(<Relation>[]) List<Relation> relations,
  }) = _Diagram;
}
