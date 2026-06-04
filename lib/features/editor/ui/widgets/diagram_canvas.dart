import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';
import 'package:talonflow/features/editor/ui/widgets/canvas_message.dart';
import 'package:talonflow/features/editor/ui/widgets/diagram_surface.dart';

class DiagramCanvas extends StatelessWidget {
  const DiagramCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagramEditorCubit, DiagramEditorState>(
      builder: (context, state) => switch (state) {
        DiagramEditorInitial() => const CanvasMessage(
          'Open a diagram from the menu, or create a new one.',
        ),
        DiagramEditorLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        DiagramEditorError(:final message) => CanvasMessage(message),
        DiagramEditorLoaded(:final diagram) => DiagramSurface(diagram: diagram),
      },
    );
  }
}
