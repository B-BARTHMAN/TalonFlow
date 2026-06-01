import 'package:flutter/material.dart';
import 'package:talonflow/core/models/entity_field.dart';
import 'package:talonflow/features/editor/ui/widgets/field_type_field.dart';

/// Bottom-sheet form for editing one [EntityField]. Returns the edited field
/// on save, or null if cancelled. It edits a local copy only — persisting is
/// the caller's job.
class FieldEditorSheet extends StatefulWidget {
  const FieldEditorSheet({required this.field, super.key});

  static Future<EntityField?> show(BuildContext context, EntityField field) {
    return showModalBottomSheet<EntityField>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FieldEditorSheet(field: field),
    );
  }

  final EntityField field;

  @override
  State<FieldEditorSheet> createState() => _FieldEditorSheetState();
}

class _FieldEditorSheetState extends State<FieldEditorSheet> {
  late EntityField _field = widget.field;
  late final _nameController = TextEditingController(text: _field.name);
  late final _defaultController = TextEditingController(
    text: _field.defaultValue ?? '',
  );
  late final _checkController = TextEditingController(text: _field.check ?? '');

  @override
  void dispose() {
    _nameController.dispose();
    _defaultController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final defaultValue = _defaultController.text.trim();
    final check = _checkController.text.trim();
    Navigator.of(context).pop(
      _field.copyWith(
        name: name,
        defaultValue: defaultValue.isEmpty ? null : defaultValue,
        check: check.isEmpty ? null : check,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            FieldTypeField(
              value: _field.type,
              onChanged: (type) =>
                  setState(() => _field = _field.copyWith(type: type)),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Primary key'),
              value: _field.isPrimaryKey,
              onChanged: (v) => setState(() {
                // A primary key is implicitly NOT NULL.
                _field = _field.copyWith(
                  isPrimaryKey: v,
                  isNullable: v ? false : _field.isNullable,
                );
              }),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Nullable'),
              subtitle: _field.isPrimaryKey
                  ? const Text('Primary keys are NOT NULL')
                  : null,
              value: _field.isNullable,
              onChanged: _field.isPrimaryKey
                  ? null
                  : (v) =>
                        setState(() => _field = _field.copyWith(isNullable: v)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Unique'),
              value: _field.isUnique,
              onChanged: (v) =>
                  setState(() => _field = _field.copyWith(isUnique: v)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto increment'),
              value: _field.isAutoIncrement,
              onChanged: (v) =>
                  setState(() => _field = _field.copyWith(isAutoIncrement: v)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _defaultController,
              decoration: const InputDecoration(
                labelText: 'Default',
                hintText: 'SQL expression, e.g. now()',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _checkController,
              decoration: const InputDecoration(
                labelText: 'Check',
                hintText: 'SQL expression, e.g. price > 0',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
