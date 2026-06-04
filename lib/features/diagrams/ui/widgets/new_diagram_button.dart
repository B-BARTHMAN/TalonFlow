import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/widgets/name_input_dialog.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';

class NewDiagramButton extends StatelessWidget {
  const NewDiagramButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () async {
        final cubit = context.read<DiagramListCubit>();
        final name = await NameInputDialog.show(
          context,
          title: 'New diagram',
          hintText: 'Diagram name',
          confirmLabel: 'Create',
        );
        if (name != null) await cubit.createDiagram(name);
      },
      icon: const Icon(Icons.add_rounded),
      label: const Text('New Diagram'),
    );
  }
}
