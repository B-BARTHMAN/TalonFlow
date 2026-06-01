import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/core/models/entity_field.dart';
import 'package:talonflow/core/models/field_type.dart';
import 'package:talonflow/core/repositories/diagram_repository.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';
import 'package:uuid/uuid.dart';

class DiagramEditorCubit extends Cubit<DiagramEditorState> {
  DiagramEditorCubit({required DiagramRepository repository})
    : _repository = repository,
      super(const DiagramEditorState());

  final DiagramRepository _repository;
  static const _uuid = Uuid();

  static const _placementOrigin = 40.0;
  static const _placementStep = 32.0;

  Future<void> openDiagram(String id) async {
    emit(state.copyWith(status: DiagramEditorStatus.loading));
    try {
      final diagram = await _repository.load(id);
      emit(
        state.copyWith(status: DiagramEditorStatus.loaded, diagram: diagram),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DiagramEditorStatus.error, error: e.toString()),
      );
    }
  }

  /// Clear the canvas back to the empty state — e.g. the open diagram was
  /// deleted from the list.
  void closeDiagram() => emit(const DiagramEditorState());

  Future<void> addEntity() async {
    final diagram = state.diagram;
    if (diagram == null) return;

    final count = diagram.entities.length;
    final position = _placementOrigin + _placementStep * count;
    final entity = Entity(
      id: _uuid.v4(),
      name: 'Entity ${count + 1}',
      x: position,
      y: position,
    );

    await _apply(diagram.copyWith(entities: [...diagram.entities, entity]));
  }

  Future<void> renameEntity(String id, String name) =>
      _updateEntity(id, (entity) => entity.copyWith(name: name));

  Future<void> deleteEntity(String id) async {
    final diagram = state.diagram;
    if (diagram == null) return;

    await _apply(
      diagram.copyWith(
        entities: diagram.entities.where((e) => e.id != id).toList(),
        // Drop relations attached to the removed table, like dropping its FKs.
        relations: diagram.relations
            .where((r) => r.parent.entityId != id && r.child.entityId != id)
            .toList(),
      ),
    );
  }

  Future<void> addField(String entityId) => _updateEntity(
    entityId,
    (entity) => entity.copyWith(
      fields: [
        ...entity.fields,
        EntityField(
          id: _uuid.v4(),
          name: 'column_${entity.fields.length + 1}',
          type: const FieldType.integer(),
        ),
      ],
    ),
  );

  Future<void> removeField(String entityId, String fieldId) => _updateEntity(
    entityId,
    (entity) => entity.copyWith(
      fields: entity.fields.where((f) => f.id != fieldId).toList(),
    ),
  );

  /// Live position update during a drag — no disk write. Persisted once when
  /// the drag ends, via [commitLayout].
  void moveEntity(String id, double dx, double dy) {
    final diagram = state.diagram;
    if (diagram == null) return;

    final entities = [
      for (final entity in diagram.entities)
        if (entity.id == id)
          entity.copyWith(x: entity.x + dx, y: entity.y + dy)
        else
          entity,
    ];
    emit(state.copyWith(diagram: diagram.copyWith(entities: entities)));
  }

  /// Persist the current layout — call once when a drag ends, not per frame.
  Future<void> commitLayout() async {
    final diagram = state.diagram;
    if (diagram != null) await _save(diagram);
  }

  /// Replace the entity with [id] using [edit], then emit + persist.
  Future<void> _updateEntity(String id, Entity Function(Entity) edit) async {
    final diagram = state.diagram;
    if (diagram == null) return;

    await _apply(
      diagram.copyWith(
        entities: [
          for (final entity in diagram.entities)
            if (entity.id == id) edit(entity) else entity,
        ],
      ),
    );
  }

  /// Emit an edited diagram immediately, then persist it.
  Future<void> _apply(Diagram updated) async {
    emit(state.copyWith(diagram: updated));
    await _save(updated);
  }

  Future<void> _save(Diagram diagram) async {
    try {
      await _repository.save(diagram);
    } catch (e, st) {
      addError(e, st);
    }
  }

  Future<void> updateField(String entityId, EntityField field) => _updateEntity(
    entityId,
    (entity) => entity.copyWith(
      fields: [
        for (final f in entity.fields)
          if (f.id == field.id) field else f,
      ],
    ),
  );
}
