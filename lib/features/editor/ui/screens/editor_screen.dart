import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_state.dart';
import 'package:talonflow/features/diagrams/ui/widgets/diagrams_drawer.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';
import 'package:talonflow/features/editor/ui/widgets/add_entity_button.dart';
import 'package:talonflow/features/editor/ui/widgets/diagram_canvas.dart';
import 'package:talonflow/features/editor/ui/widgets/editor_app_bar.dart';

/// The app's main screen: the diagram canvas, with the diagram browser in a
/// drawer. Closes the open diagram if it's deleted, and reports failed saves.
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DiagramListCubit, DiagramListState>(
          listenWhen: (prev, curr) => curr is DiagramListLoaded,
          listener: (context, state) {
            if (state is! DiagramListLoaded) return;
            final editor = context.read<DiagramEditorCubit>();
            final open = editor.state.diagramOrNull;
            if (open != null && !state.diagrams.any((d) => d.id == open.id)) {
              editor.closeDiagram();
            }
          },
        ),
        BlocListener<DiagramEditorCubit, DiagramEditorState>(
          listenWhen: (prev, curr) =>
              curr is DiagramEditorLoaded && curr.saveError != null,
          listener: (context, state) {
            final error = state is DiagramEditorLoaded ? state.saveError : null;
            if (error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error)),
              );
            }
          },
        ),
      ],
      child: const Scaffold(
        appBar: EditorAppBar(),
        drawer: DiagramsDrawer(),
        body: DiagramCanvas(),
        floatingActionButton: AddEntityButton(),
      ),
    );
  }
}
