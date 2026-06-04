import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';

/// App bar for the editor: shows the open diagram's name, or the app name when
/// nothing is open. Rebuilds only when the name changes — not on every drag.
class EditorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<DiagramEditorCubit, DiagramEditorState>(
        buildWhen: (prev, curr) =>
            prev.diagramOrNull?.name != curr.diagramOrNull?.name,
        builder: (context, state) =>
            Text(state.diagramOrNull?.name ?? 'TalonFlow'),
      ),
    );
  }
}
