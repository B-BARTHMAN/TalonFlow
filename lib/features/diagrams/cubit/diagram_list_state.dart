import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talonflow/core/models/diagram.dart';

part 'diagram_list_state.freezed.dart';

@freezed
sealed class DiagramListState with _$DiagramListState {
  const factory DiagramListState.initial() = DiagramListInitial;
  const factory DiagramListState.loading() = DiagramListLoading;
  const factory DiagramListState.loaded(List<Diagram> diagrams) =
      DiagramListLoaded;
  const factory DiagramListState.error(String message) = DiagramListError;
}
