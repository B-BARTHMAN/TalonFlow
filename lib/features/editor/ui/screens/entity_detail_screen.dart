import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/core/widgets/confirm_dialog.dart';
import 'package:talonflow/core/widgets/name_input_dialog.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';
import 'package:talonflow/features/editor/ui/widgets/entity_field_tile.dart';

class EntityDetailScreen extends StatelessWidget {
  const EntityDetailScreen({required this.entityId, super.key});

  final String entityId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiagramEditorCubit, DiagramEditorState>(
      // Entity gone (deleted here, or its diagram closed) → leave the page.
      listenWhen: (prev, curr) =>
          _entityIn(prev, entityId) != null &&
          _entityIn(curr, entityId) == null,
      listener: (context, state) {
        if (context.canPop()) context.pop();
      },
      builder: (context, state) {
        final entity = _entityIn(state, entityId);
        if (entity == null) {
          return const Scaffold(body: SizedBox.shrink());
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(entity.name),
            actions: [
              PopupMenuButton<_EntityAction>(
                onSelected: (action) async {
                  switch (action) {
                    case _EntityAction.rename:
                      final name = await NameInputDialog.show(
                        context,
                        title: 'Rename entity',
                        initialValue: entity.name,
                        hintText: 'Table name',
                        confirmLabel: 'Rename',
                      );
                      if (name == null || !context.mounted) return;
                      await context.read<DiagramEditorCubit>().renameEntity(
                        entity.id,
                        name,
                      );
                    case _EntityAction.delete:
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: 'Delete entity',
                        message:
                            'Delete "${entity.name}" and its relations? '
                            'This cannot be undone.',
                        confirmLabel: 'Delete',
                      );
                      if (!confirmed || !context.mounted) return;
                      await context.read<DiagramEditorCubit>().deleteEntity(
                        entity.id,
                      );
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _EntityAction.rename,
                    child: Text('Rename'),
                  ),
                  PopupMenuItem(
                    value: _EntityAction.delete,
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => unawaited(
              context.read<DiagramEditorCubit>().addField(entity.id),
            ),
            child: const Icon(Icons.add),
          ),
          body: entity.fields.isEmpty
              ? const Center(child: Text('No fields yet. Tap + to add one.'))
              : ListView.builder(
                  itemCount: entity.fields.length,
                  itemBuilder: (context, index) => EntityFieldTile(
                    entityId: entity.id,
                    field: entity.fields[index],
                  ),
                ),
        );
      },
    );
  }
}

Entity? _entityIn(DiagramEditorState state, String id) {
  final entities = state.diagram?.entities ?? const <Entity>[];
  final matches = entities.where((e) => e.id == id);
  return matches.isEmpty ? null : matches.first;
}

enum _EntityAction { rename, delete }
