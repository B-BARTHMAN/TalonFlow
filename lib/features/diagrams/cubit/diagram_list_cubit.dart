import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/core/repositories/diagram_repository.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_state.dart';

class DiagramListCubit extends Cubit<DiagramListState> {
  DiagramListCubit({required DiagramRepository repository})
    : _repository = repository,
      super(const DiagramListState.initial());

  final DiagramRepository _repository;

  List<Diagram> get _diagrams => switch (state) {
    DiagramListLoaded(:final diagrams) => diagrams,
    DiagramListInitial() ||
    DiagramListLoading() ||
    DiagramListError() => const [],
  };

  Future<void> loadDiagrams() async {
    emit(const DiagramListState.loading());
    try {
      emit(DiagramListState.loaded(await _repository.loadAll()));
    } catch (e) {
      emit(DiagramListState.error(e.toString()));
    }
  }

  Future<void> createDiagram(String name) async {
    try {
      final diagram = await _repository.create(name);
      emit(DiagramListState.loaded([..._diagrams, diagram]));
    } catch (e) {
      emit(DiagramListState.error(e.toString()));
    }
  }

  Future<void> renameDiagram(String id, String name) async {
    try {
      final diagram = _diagrams.firstWhere((d) => d.id == id);
      await _repository.rename(diagram, name);
      emit(
        DiagramListState.loaded([
          for (final d in _diagrams)
            if (d.id == id) d.copyWith(name: name) else d,
        ]),
      );
    } catch (e) {
      emit(DiagramListState.error(e.toString()));
    }
  }

  Future<void> deleteDiagram(String id) async {
    try {
      await _repository.delete(id);
      emit(
        DiagramListState.loaded(_diagrams.where((d) => d.id != id).toList()),
      );
    } catch (e) {
      emit(DiagramListState.error(e.toString()));
    }
  }
}
