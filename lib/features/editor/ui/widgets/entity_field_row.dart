import 'package:flutter/material.dart';
import 'package:talonflow/core/models/entity_field.dart';
import 'package:talonflow/core/models/field_type.dart';

class EntityFieldRow extends StatelessWidget {
  const EntityFieldRow({required this.field, super.key});

  final EntityField field;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final notes = <String>[
      if (field.defaultValue != null) '= ${field.defaultValue}',
      if (field.check != null) 'check (${field.check})',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 14,
                child: field.isPrimaryKey
                    ? Icon(Icons.key, size: 14, color: colors.primary)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  field.name,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                field.isNullable ? '${field.type.label}?' : field.type.label,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 2),
              child: Text(
                notes.join('  ·  '),
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact, display-only SQL type labels for the canvas. (Full DDL type
/// strings for export are a separate concern, added with the exporter.)
extension FieldTypeLabel on FieldType {
  String get label => switch (this) {
    SmallIntType() => 'smallint',
    IntegerType() => 'int',
    BigIntType() => 'bigint',
    DecimalType(:final precision, :final scale) =>
      'decimal($precision, $scale)',
    RealType() => 'real',
    DoubleType() => 'double',
    BooleanType() => 'bool',
    CharType(:final length) => 'char($length)',
    VarcharType(:final length) => 'varchar($length)',
    TextType() => 'text',
    DateType() => 'date',
    TimeType(:final withTimeZone) => withTimeZone ? 'timetz' : 'time',
    TimestampType(:final withTimeZone) =>
      withTimeZone ? 'timestamptz' : 'timestamp',
    UuidType() => 'uuid',
    JsonType() => 'json',
    JsonbType() => 'jsonb',
    BlobType() => 'blob',
    EnumType(:final values) => 'enum(${values.length})',
  };
}
