import 'package:talonflow/core/models/diagram.dart';

enum DiagramEditorStatus { initial, loading, loaded, error }

class DiagramEditorState {
  const DiagramEditorState({
    this.status = DiagramEditorStatus.initial,
    this.diagram,
    this.error,
  });

  final DiagramEditorStatus status;

  final Diagram? diagram;
  final String? error;

  DiagramEditorState copyWith({
    DiagramEditorStatus? status,
    Diagram? diagram,
    String? error,
  }) => DiagramEditorState(
    status: status ?? this.status,
    diagram: diagram ?? this.diagram,
    error: error ?? this.error,
  );
}
