import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/core/widgets/confirm_dialog.dart';
import 'package:talonflow/core/widgets/name_input_dialog.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';

class DiagramTile extends StatelessWidget {
  const DiagramTile({required this.diagram, super.key});

  final Diagram diagram;

  void _open(BuildContext context) {
    unawaited(context.read<DiagramEditorCubit>().openDiagram(diagram.id));
    Scaffold.of(context).closeDrawer();
  }

  Future<void> _rename(BuildContext context) async {
    final cubit = context.read<DiagramListCubit>();
    final name = await NameInputDialog.show(
      context,
      title: 'Rename diagram',
      initialValue: diagram.name,
      hintText: 'Diagram name',
      confirmLabel: 'Rename',
    );
    if (name != null) await cubit.renameDiagram(diagram.id, name);
  }

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<DiagramListCubit>();
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete diagram',
      message: 'Delete "${diagram.name}"? This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (confirmed) await cubit.deleteDiagram(diagram.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.account_tree_outlined),
      title: Text(diagram.name),
      onTap: () => _open(context),
      trailing: PopupMenuButton<_TileAction>(
        onSelected: (action) {
          switch (action) {
            case _TileAction.rename:
              unawaited(_rename(context));
            case _TileAction.delete:
              unawaited(_delete(context));
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
