import 'package:go_router/go_router.dart';
import 'package:talonflow/config/routing/routes.dart';
import 'package:talonflow/features/editor/ui/screens/editor_screen.dart';
import 'package:talonflow/features/editor/ui/screens/entity_detail_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const EditorScreen(),
      routes: [
        GoRoute(
          path: Routes.entity,
          builder: (context, state) =>
              EntityDetailScreen(entityId: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
