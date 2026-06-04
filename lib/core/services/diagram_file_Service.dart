import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:talonflow/core/models/diagram.dart';

class DiagramFileService {
  static const _dirName = 'diagrams';

  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    return Directory('${base.path}/$_dirName').create(recursive: true);
  }

  File _file(Directory dir, String id) => File('${dir.path}/$id.json');

  Future<List<Diagram>> loadAll() async {
    final dir = await _dir();
    final diagrams = <Diagram>[];
    await for (final entity in dir.list()) {
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      try {
        final json =
            jsonDecode(await entity.readAsString()) as Map<String, dynamic>;
        diagrams.add(Diagram.fromJson(json));
      } on Object catch (_) {
        // Skip a corrupt/unreadable file rather than failing the whole load.
        continue;
      }
    }
    return diagrams;
  }

  Future<Diagram> load(String id) async {
    final file = _file(await _dir(), id);
    if (!file.existsSync()) {
      throw FileSystemException('Diagram not found', file.path);
    }
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return Diagram.fromJson(json);
  }

  Future<void> save(Diagram diagram) async {
    final file = _file(await _dir(), diagram.id);
    await file.writeAsString(jsonEncode(diagram.toJson()));
  }

  Future<void> delete(String id) async {
    final file = _file(await _dir(), id);
    if (file.existsSync()) await file.delete();
  }
}
