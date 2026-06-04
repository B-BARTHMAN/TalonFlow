import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/core/widgets/confirm_dialog.dart';
import 'package:talonflow/core/widgets/name_input_dialog.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';

/// Overflow menu for an entity: rename or delete it.
class EntityMenuButton extends StatelessWidget {
  const EntityMenuButton({required this.entity, super.key});

  final Entity entity;

  Future<void> _rename(BuildContext context) async {
    final cubit = context.read<DiagramEditorCubit>();
    final name = await NameInputDialog.show(
      context,
      title: 'Rename entity',
      initialValue: entity.name,
      hintText: 'Table name',
      confirmLabel: 'Rename',
    );
    if (name != null) await cubit.renameEntity(entity.id, name);
  }

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<DiagramEditorCubit>();
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete entity',
      message:
          'Delete "${entity.name}" and its relations? '
          'This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (confirmed) await cubit.deleteEntity(entity.id);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_EntityAction>(
      onSelected: (action) {
        switch (action) {
          case _EntityAction.rename:
            unawaited(_rename(context));
          case _EntityAction.delete:
            unawaited(_delete(context));
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: _EntityAction.rename, child: Text('Rename')),
        PopupMenuItem(value: _EntityAction.delete, child: Text('Delete')),
      ],
    );
  }
}

enum _EntityAction { rename, delete }
