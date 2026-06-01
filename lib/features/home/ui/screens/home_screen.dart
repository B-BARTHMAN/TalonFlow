import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_state.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';
import 'package:talonflow/features/editor/ui/widgets/add_entity_button.dart';
import 'package:talonflow/features/editor/ui/widgets/diagram_canvas.dart';
import 'package:talonflow/features/sidebar/ui/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sidebarOpen = false;

  void _openSidebar() => setState(() => _sidebarOpen = true);
  void _closeSidebar() => setState(() => _sidebarOpen = false);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // A diagram finished opening → get the sidebar out of the way.
        BlocListener<DiagramEditorCubit, DiagramEditorState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              curr.status == DiagramEditorStatus.loaded,
          listener: (context, state) => _closeSidebar(),
        ),
        // The open diagram was deleted from the list → clear the canvas.
        BlocListener<DiagramListCubit, DiagramListState>(
          listenWhen: (prev, curr) =>
              curr.diagrams.length < prev.diagrams.length,
          listener: (context, state) {
            final editor = context.read<DiagramEditorCubit>();
            final open = editor.state.diagram;
            if (open != null && !state.diagrams.any((d) => d.id == open.id)) {
              editor.closeDiagram();
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: _openSidebar,
                icon: const Icon(Icons.menu_rounded),
              ),
            ),
            body: const DiagramCanvas(),
            floatingActionButton: const AddEntityButton(),
          ),
          Sidebar(isOpen: _sidebarOpen, onClose: _closeSidebar),
        ],
      ),
    );
  }
}
