import 'package:talonflow/core/models/diagram.dart';

enum DiagramListStatus { initial, loading, loaded, error }

class DiagramListState {
  const DiagramListState({
    this.status = DiagramListStatus.initial,
    this.diagrams = const [],
    this.error,
  });

  final DiagramListStatus status;
  final List<Diagram> diagrams;
  final String? error;

  DiagramListState copyWith({
    DiagramListStatus? status,
    List<Diagram>? diagrams,
    String? error,
  }) => DiagramListState(
    status: status ?? this.status,
    diagrams: diagrams ?? this.diagrams,
    error: error ?? this.error,
  );
}
