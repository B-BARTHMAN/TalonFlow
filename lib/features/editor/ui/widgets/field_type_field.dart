import 'package:flutter/material.dart';
import 'package:talonflow/core/models/field_type.dart';

/// A form control for picking a [FieldType] and editing its parameters
/// (length, precision/scale, time zone, enum values).
class FieldTypeField extends StatelessWidget {
  const FieldTypeField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final FieldType value;
  final ValueChanged<FieldType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Type',
            border: OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<_TypeKind>(
              value: _kindOf(value),
              isExpanded: true,
              items: [
                for (final kind in _TypeKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (kind) {
                if (kind != null) onChanged(_defaultFor(kind));
              },
            ),
          ),
        ),
        ..._params(),
      ],
    );
  }

  List<Widget> _params() {
    return switch (value) {
      DecimalType(:final precision, :final scale) => [
        _numberField(
          fieldKey: 'precision',
          label: 'Precision',
          current: precision,
          onChanged: (n) =>
              onChanged(FieldType.decimal(precision: n, scale: scale)),
        ),
        _numberField(
          fieldKey: 'scale',
          label: 'Scale',
          current: scale,
          onChanged: (n) =>
              onChanged(FieldType.decimal(precision: precision, scale: n)),
        ),
      ],
      CharType(:final length) => [
        _numberField(
          fieldKey: 'char-length',
          label: 'Length',
          current: length,
          onChanged: (n) => onChanged(FieldType.char(length: n)),
        ),
      ],
      VarcharType(:final length) => [
        _numberField(
          fieldKey: 'varchar-length',
          label: 'Length',
          current: length,
          onChanged: (n) => onChanged(FieldType.varchar(length: n)),
        ),
      ],
      TimeType(:final withTimeZone) => [
        _timeZoneSwitch(
          current: withTimeZone,
          onChanged: (v) => onChanged(FieldType.time(withTimeZone: v)),
        ),
      ],
      TimestampType(:final withTimeZone) => [
        _timeZoneSwitch(
          current: withTimeZone,
          onChanged: (v) => onChanged(FieldType.timestamp(withTimeZone: v)),
        ),
      ],
      EnumType(:final values) => [_enumField(values)],
      SmallIntType() ||
      IntegerType() ||
      BigIntType() ||
      RealType() ||
      DoubleType() ||
      BooleanType() ||
      TextType() ||
      DateType() ||
      UuidType() ||
      JsonType() ||
      JsonbType() ||
      BlobType() => const <Widget>[],
    };
  }

  Widget _numberField({
    required String fieldKey,
    required String label,
    required int current,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        key: ValueKey(fieldKey),
        initialValue: '$current',
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (text) {
          final n = int.tryParse(text);
          if (n != null) onChanged(n);
        },
      ),
    );
  }

  Widget _timeZoneSwitch({
    required bool current,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('With time zone'),
      value: current,
      onChanged: onChanged,
    );
  }

  Widget _enumField(List<String> values) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        key: const ValueKey('enum-values'),
        initialValue: values.join(', '),
        decoration: const InputDecoration(
          labelText: 'Values',
          helperText: 'Comma-separated, e.g. active, archived, banned',
        ),
        onChanged: (text) {
          final parsed = [
            for (final v in text.split(','))
              if (v.trim().isNotEmpty) v.trim(),
          ];
          onChanged(FieldType.enumeration(parsed));
        },
      ),
    );
  }
}

_TypeKind _kindOf(FieldType type) => switch (type) {
  SmallIntType() => _TypeKind.smallInt,
  IntegerType() => _TypeKind.integer,
  BigIntType() => _TypeKind.bigInt,
  DecimalType() => _TypeKind.decimal,
  RealType() => _TypeKind.real,
  DoubleType() => _TypeKind.double,
  BooleanType() => _TypeKind.boolean,
  CharType() => _TypeKind.char,
  VarcharType() => _TypeKind.varchar,
  TextType() => _TypeKind.text,
  DateType() => _TypeKind.date,
  TimeType() => _TypeKind.time,
  TimestampType() => _TypeKind.timestamp,
  UuidType() => _TypeKind.uuid,
  JsonType() => _TypeKind.json,
  JsonbType() => _TypeKind.jsonb,
  BlobType() => _TypeKind.blob,
  EnumType() => _TypeKind.enumeration,
};

FieldType _defaultFor(_TypeKind kind) => switch (kind) {
  _TypeKind.smallInt => const FieldType.smallInt(),
  _TypeKind.integer => const FieldType.integer(),
  _TypeKind.bigInt => const FieldType.bigInt(),
  _TypeKind.decimal => const FieldType.decimal(),
  _TypeKind.real => const FieldType.real(),
  _TypeKind.double => const FieldType.doublePrecision(),
  _TypeKind.boolean => const FieldType.boolean(),
  _TypeKind.char => const FieldType.char(),
  _TypeKind.varchar => const FieldType.varchar(),
  _TypeKind.text => const FieldType.text(),
  _TypeKind.date => const FieldType.date(),
  _TypeKind.time => const FieldType.time(),
  _TypeKind.timestamp => const FieldType.timestamp(),
  _TypeKind.uuid => const FieldType.uuid(),
  _TypeKind.json => const FieldType.json(),
  _TypeKind.jsonb => const FieldType.jsonb(),
  _TypeKind.blob => const FieldType.blob(),
  _TypeKind.enumeration => const FieldType.enumeration([]),
};

enum _TypeKind {
  smallInt('smallint'),
  integer('int'),
  bigInt('bigint'),
  decimal('decimal'),
  real('real'),
  double('double'),
  boolean('bool'),
  char('char'),
  varchar('varchar'),
  text('text'),
  date('date'),
  time('time'),
  timestamp('timestamp'),
  uuid('uuid'),
  json('json'),
  jsonb('jsonb'),
  blob('blob'),
  enumeration('enum')
  ;

  const _TypeKind(this.label);

  final String label;
}
