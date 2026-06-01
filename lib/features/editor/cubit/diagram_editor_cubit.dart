import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/entity.dart';
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

  void closeDiagram() => emit(const DiagramEditorState());

  Future<void> addEntity() async {
    final diagram = state.diagram;
    if (diagram == null) return;

    // Stagger new nodes down-right from the top-left so they don't stack;
    // they're meant to be dragged into place.
    final count = diagram.entities.length;
    final position = _placementOrigin + _placementStep * count;
    final entity = Entity(
      id: _uuid.v4(),
      name: 'Entity ${count + 1}',
      x: position,
      y: position,
    );

    final updated = diagram.copyWith(entities: [...diagram.entities, entity]);
    emit(state.copyWith(diagram: updated));
    try {
      await _repository.save(updated);
    } catch (e, st) {
      addError(e, st);
    }
  }

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
    if (diagram == null) return;
    try {
      await _repository.save(diagram);
    } catch (e, st) {
      addError(e, st);
    }
  }
}
