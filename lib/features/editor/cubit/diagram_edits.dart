import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/core/models/entity_field.dart';

extension DiagramEdits on Diagram {
  Diagram addEntity(Entity entity) => copyWith(entities: [...entities, entity]);

  Diagram removeEntity(String id) => copyWith(
    entities: entities.where((e) => e.id != id).toList(),
    relations: relations
        .where((r) => r.parent.entityId != id && r.child.entityId != id)
        .toList(),
  );

  Diagram updateEntity(String id, Entity Function(Entity) edit) => copyWith(
    entities: [
      for (final e in entities)
        if (e.id == id) edit(e) else e,
    ],
  );
}

extension EntityEdits on Entity {
  Entity moveBy(double dx, double dy) => copyWith(x: x + dx, y: dy);

  Entity addField(EntityField field) => copyWith(fields: [...fields, field]);

  Entity removeField(String fieldId) =>
      copyWith(fields: fields.where((f) => f.id != fieldId).toList());

  Entity updateField(EntityField field) => copyWith(
    fields: [
      for (final f in fields)
        if (f.id == field.id) field else f,
    ],
  );
}
