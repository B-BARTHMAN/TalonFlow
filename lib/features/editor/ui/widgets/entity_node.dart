import 'package:flutter/material.dart';
import 'package:talonflow/core/models/entity.dart';
import 'package:talonflow/features/editor/ui/widgets/entity_field_row.dart';

class EntityNode extends StatelessWidget {
  const EntityNode({required this.entity, super.key});

  static const _minWidth = 160.0;
  static const _maxWidth = 280.0;

  final Entity entity;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: _minWidth,
        maxWidth: _maxWidth,
      ),
      child: Material(
        color: colors.surfaceContainer,
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ColoredBox(
                color: colors.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    entity.name,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              for (final field in entity.fields) EntityFieldRow(field: field),
            ],
          ),
        ),
      ),
    );
  }
}
