import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/entity_field.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/ui/widgets/entity_field_row.dart';
import 'package:talonflow/features/editor/ui/widgets/field_editor_sheet.dart';

/// One column row in the entity detail list: name, SQL type, the constraints
/// that are set, and a delete button. Tap to edit.
class EntityFieldTile extends StatelessWidget {
  const EntityFieldTile({
    required this.entityId,
    required this.field,
    super.key,
  });

  final String entityId;
  final EntityField field;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      field.type.label,
      if (!field.isNullable) 'NOT NULL',
      if (field.isUnique) 'UNIQUE',
      if (field.isAutoIncrement) 'AUTO INC',
    ];
    return ListTile(
      leading: field.isPrimaryKey ? const Icon(Icons.key) : null,
      title: Text(field.name),
      subtitle: Text(parts.join(' · ')),
      onTap: () async {
        final updated = await FieldEditorSheet.show(context, field);
        if (updated == null || !context.mounted) return;
        await context.read<DiagramEditorCubit>().updateField(entityId, updated);
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Remove field',
        onPressed: () => unawaited(
          context.read<DiagramEditorCubit>().removeField(entityId, field.id),
        ),
      ),
    );
  }
}
