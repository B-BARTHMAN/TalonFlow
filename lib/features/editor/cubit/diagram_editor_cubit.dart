import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/id.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/core/models/entity_field.dart';
import 'package:talonflow/core/models/field_type.dart';
import 'package:talonflow/core/repositories/diagram_repository.dart';
import 'package:talonflow/features/editor/cubit/diagram_edits.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';

class DiagramEditorCubit extends Cubit<DiagramEditorState> {
  DiagramEditorCubit({required DiagramRepository repository})
    : _repository = repository,
      super(const DiagramEditorState.initial());

  final DiagramRepository _repository;

  static const _placementOrigin = 40.0;
  static const _placementStep = 32.0;

  Future<void> openDiagram(String id) async {
    emit(const DiagramEditorState.loading());
    try {
      emit(DiagramEditorState.loaded(await _repository.load(id)));
    } catch (e) {
      emit(DiagramEditorState.error(e.toString()));
    }
  }

  void closeDiagram() => emit(const DiagramEditorState.initial());

  Future<void> addEntity() {
    final count = state.diagramOrNull?.entities.length ?? 0;
    final position = _placementOrigin + _placementStep * count;
    return _edit(
      (d) => d.addEntity(
        Entity(
          id: Id.generate(),
          name: 'Entity ${count + 1}',
          x: position,
          y: position,
        ),
      ),
    );
  }

  Future<void> renameEntity(String id, String name) =>
      _edit((d) => d.updateEntity(id, (e) => e.copyWith(name: name)));

  Future<void> deleteEntity(String id) => _edit((d) => d.removeEntity(id));

  Future<void> addField(String entityId) => _edit(
    (d) => d.updateEntity(
      entityId,
      (e) => e.addField(
        EntityField(
          id: Id.generate(),
          name: 'column_${e.fields.length + 1}',
          type: const FieldType.integer(),
        ),
      ),
    ),
  );

  Future<void> updateField(String entityId, EntityField field) =>
      _edit((d) => d.updateEntity(entityId, (e) => e.updateField(field)));

  Future<void> removeField(String entityId, String fieldId) =>
      _edit((d) => d.updateEntity(entityId, (e) => e.removeField(fieldId)));

  /// Live position update during a drag — no disk write. Persisted by
  /// [commitLayout] when the drag ends.
  void moveEntity(String id, double dx, double dy) {
    final diagram = state.diagramOrNull;
    if (diagram == null) return;
    emit(
      DiagramEditorState.loaded(
        diagram.updateEntity(id, (e) => e.moveBy(dx, dy)),
      ),
    );
  }

  Future<void> commitLayout() async {
    final diagram = state.diagramOrNull;
    if (diagram != null) await _save(diagram);
  }

  /// Apply a transform, emit optimistically, then persist.
  Future<void> _edit(Diagram Function(Diagram) transform) async {
    final diagram = state.diagramOrNull;
    if (diagram == null) return;
    final updated = transform(diagram);
    emit(DiagramEditorState.loaded(updated));
    await _save(updated);
  }

  /// Persist [diagram]. On failure, keep it on screen and surface the error.
  Future<void> _save(Diagram diagram) async {
    try {
      await _repository.save(diagram);
    } catch (e) {
      emit(DiagramEditorState.loaded(diagram, saveError: e.toString()));
    }
  }
}
