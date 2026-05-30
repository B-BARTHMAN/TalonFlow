import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/core/services/diagram_file_Service.dart';
import 'package:uuid/uuid.dart';

class DiagramRepository {
  DiagramRepository({required DiagramFileService service}) : _service = service;

  final DiagramFileService _service;
  static const _uuid = Uuid();

  Future<List<Diagram>> loadAll() => _service.loadAll();

  Future<Diagram> load(String id) => _service.load(id);

  Future<Diagram> create(String name) async {
    final diagram = Diagram(id: _uuid.v4(), name: name);
    await _service.save(diagram);
    return diagram;
  }

  Future<void> save(Diagram diagram) => _service.save(diagram);

  Future<void> rename(Diagram diagram, String name) =>
      _service.save(diagram.copyWith(name: name));

  Future<void> delete(String id) => _service.delete(id);
}
