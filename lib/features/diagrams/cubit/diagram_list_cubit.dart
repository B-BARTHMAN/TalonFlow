import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/repositories/diagram_repository.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_state.dart';

class DiagramListCubit extends Cubit<DiagramListState> {
  DiagramListCubit({required DiagramRepository repository})
    : _repository = repository,
      super(const DiagramListState());

  final DiagramRepository _repository;

  Future<void> loadDiagrams() async {
    emit(state.copyWith(status: DiagramListStatus.loading));
    try {
      final diagrams = await _repository.loadAll();
      emit(
        state.copyWith(status: DiagramListStatus.loaded, diagrams: diagrams),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DiagramListStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> createDiagram(String name) async {
    try {
      final diagram = await _repository.create(name);
      emit(state.copyWith(diagrams: [...state.diagrams, diagram]));
    } catch (e) {
      emit(
        state.copyWith(status: DiagramListStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> renameDiagram(String id, String name) async {
    try {
      final diagram = state.diagrams.firstWhere((d) => d.id == id);
      await _repository.rename(diagram, name);
      emit(
        state.copyWith(
          diagrams: [
            for (final d in state.diagrams)
              if (d.id == id) d.copyWith(name: name) else d,
          ],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DiagramListStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> deleteDiagram(String id) async {
    try {
      await _repository.delete(id);
      emit(
        state.copyWith(
          diagrams: state.diagrams.where((d) => d.id != id).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DiagramListStatus.error, error: e.toString()),
      );
    }
  }
}
