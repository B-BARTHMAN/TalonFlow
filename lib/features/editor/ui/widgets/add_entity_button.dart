import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';

class AddEntityButton extends StatelessWidget {
  const AddEntityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagramEditorCubit, DiagramEditorState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status != DiagramEditorStatus.loaded) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () async {
            await context.read<DiagramEditorCubit>().addEntity();
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }
}
