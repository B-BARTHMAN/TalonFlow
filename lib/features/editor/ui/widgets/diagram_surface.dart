import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/ui/widgets/entity_node.dart';

/// The zoomable, pannable surface showing a diagram's entities — and, later,
/// the relations drawn between them. Nodes can be dragged to reposition.
class DiagramSurface extends StatefulWidget {
  const DiagramSurface({required this.diagram, super.key});

  final Diagram diagram;

  @override
  State<DiagramSurface> createState() => _DiagramSurfaceState();
}

class _DiagramSurfaceState extends State<DiagramSurface> {
  // A large fixed working area to pan within; a diagram constant.
  static const _canvasSize = 5000.0;

  final _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNodeDrag(String id, Offset delta) {
    // Screen delta → canvas delta: undo the current zoom so a node tracks the
    // pointer at any scale.
    final scale = _controller.value.getMaxScaleOnAxis();
    context.read<DiagramEditorCubit>().moveEntity(
      id,
      delta.dx / scale,
      delta.dy / scale,
    );
  }

  void _commitLayout() {
    unawaited(context.read<DiagramEditorCubit>().commitLayout());
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _controller,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.25,
      maxScale: 4,
      child: SizedBox(
        width: _canvasSize,
        height: _canvasSize,
        child: Stack(
          children: [
            for (final entity in widget.diagram.entities)
              Positioned(
                left: entity.x,
                top: entity.y,
                child: GestureDetector(
                  onPanUpdate: (details) =>
                      _onNodeDrag(entity.id, details.delta),
                  onPanEnd: (_) => _commitLayout(),
                  child: EntityNode(entity: entity),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
