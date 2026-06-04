import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talonflow/core/models/diagram.dart';

part 'diagram_editor_state.freezed.dart';

@freezed
sealed class DiagramEditorState with _$DiagramEditorState {
  const factory DiagramEditorState.initial() = DiagramEditorInitial;
  const factory DiagramEditorState.loading() = DiagramEditorLoading;
  const factory DiagramEditorState.loaded(
    Diagram diagram, {
    String? saveError,
  }) = DiagramEditorLoaded;
  const factory DiagramEditorState.error(String message) = DiagramEditorError;

  const DiagramEditorState._();

  /// The open diagram, or null when nothing is loaded.
  Diagram? get diagramOrNull => switch (this) {
    DiagramEditorLoaded(:final diagram) => diagram,
    DiagramEditorInitial() ||
    DiagramEditorLoading() ||
    DiagramEditorError() => null,
  };
}
