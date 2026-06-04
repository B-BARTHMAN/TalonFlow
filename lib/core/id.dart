import 'package:uuid/uuid.dart';

/// One source for the ids used across the app (diagrams, entities, fields),
/// so id creation isn't scattered between layers.
abstract final class Id {
  static const _uuid = Uuid();

  static String generate() => _uuid.v4();
}
