import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';
import 'package:talonflow/features/diagrams/ui/dialogs/confirm_delete_dialog.dart';
import 'package:talonflow/features/diagrams/ui/dialogs/diagram_name_dialog.dart';

class DiagramTile extends StatelessWidget {
  const DiagramTile({required this.diagram, super.key});

  final Diagram diagram;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.account_tree_outlined),
      title: Text(diagram.name),
      onTap: () {},
      trailing: PopupMenuButton<_TileAction>(
        onSelected: (action) async {
          final cubit = context.read<DiagramListCubit>();
          switch (action) {
            case _TileAction.rename:
              final name = await DiagramNameDialog.show(
                context,
                initialName: diagram.name,
              );
              if (name != null) await cubit.renameDiagram(diagram.id, name);
            case _TileAction.delete:
              final confirmed = await ConfirmDeleteDialog.show(
                context,
                name: diagram.name,
              );
              if (confirmed) await cubit.deleteDiagram(diagram.id);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: _TileAction.rename, child: Text('Rename')),
          PopupMenuItem(value: _TileAction.delete, child: Text('Delete')),
        ],
      ),
    );
  }
}

enum _TileAction { rename, delete }
