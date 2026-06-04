import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_state.dart';
import 'package:talonflow/features/editor/ui/widgets/entity_field_tile.dart';
import 'package:talonflow/features/editor/ui/widgets/entity_menu_button.dart';

class EntityDetailScreen extends StatelessWidget {
  const EntityDetailScreen({required this.entityId, super.key});

  final String entityId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiagramEditorCubit, DiagramEditorState>(
      // Entity gone (deleted here, or its diagram closed) → leave the page.
      listenWhen: (prev, curr) =>
          _entityIn(prev.diagramOrNull, entityId) != null &&
          _entityIn(curr.diagramOrNull, entityId) == null,
      listener: (context, state) {
        if (context.canPop()) context.pop();
      },
      builder: (context, state) {
        final entity = _entityIn(state.diagramOrNull, entityId);
        if (entity == null) {
          return const Scaffold(body: SizedBox.shrink());
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(entity.name),
            actions: [EntityMenuButton(entity: entity)],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => unawaited(
              context.read<DiagramEditorCubit>().addField(entity.id),
            ),
            child: const Icon(Icons.add),
          ),
          body: entity.fields.isEmpty
              ? const Center(child: Text('No fields yet. Tap + to add one.'))
              : ListView(
                  children: [
                    for (final field in entity.fields)
                      EntityFieldTile(entityId: entity.id, field: field),
                  ],
                ),
        );
      },
    );
  }
}

Entity? _entityIn(Diagram? diagram, String id) {
  if (diagram == null) return null;
  for (final entity in diagram.entities) {
    if (entity.id == id) return entity;
  }
  return null;
}
