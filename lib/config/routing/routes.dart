abstract final class Routes {
  static const home = '/';
  static const entity = 'entity/:id';

  static String entityPath(String id) => '/entity/$id';
}
