import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_type.freezed.dart';

/// The SQL data type of an [EntityField].
///
/// A sealed union, so parameterised types (`varchar`, `decimal`, `enumeration`)
/// carry their own configuration and can never hold an invalid combination —
/// a `boolean` simply has nowhere to put a length. Handle every case with an
/// exhaustive `switch`; the compiler will tell you when you miss one.
@freezed
sealed class FieldType with _$FieldType {
  // ── Integers ──────────────────────────────────────────────────────────
  const factory FieldType.smallInt() = SmallIntType;
  const factory FieldType.integer() = IntegerType;
  const factory FieldType.bigInt() = BigIntType;

  // ── Numerics ──────────────────────────────────────────────────────────
  const factory FieldType.decimal({
    @Default(10) int precision,
    @Default(0) int scale,
  }) = DecimalType;
  const factory FieldType.real() = RealType;
  const factory FieldType.doublePrecision() = DoubleType;

  // ── Boolean ───────────────────────────────────────────────────────────
  const factory FieldType.boolean() = BooleanType;

  // ── Text ──────────────────────────────────────────────────────────────
  const factory FieldType.char({@Default(1) int length}) = CharType;
  const factory FieldType.varchar({@Default(255) int length}) = VarcharType;
  const factory FieldType.text() = TextType;

  // ── Temporal ──────────────────────────────────────────────────────────
  const factory FieldType.date() = DateType;
  const factory FieldType.time({@Default(false) bool withTimeZone}) = TimeType;
  const factory FieldType.timestamp({@Default(false) bool withTimeZone}) =
      TimestampType;

  // ── Other ─────────────────────────────────────────────────────────────
  const factory FieldType.uuid() = UuidType;
  const factory FieldType.json() = JsonType;
  const factory FieldType.jsonb() = JsonbType;
  const factory FieldType.blob() = BlobType;

  /// A user-defined enum, e.g. `('active', 'archived', 'banned')`.
  const factory FieldType.enumeration(List<String> values) = EnumType;
}
