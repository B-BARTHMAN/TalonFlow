import 'package:go_router/go_router.dart';
import 'package:talonflow/config/routing/routes.dart';
import 'package:talonflow/config/routing/shell.dart';
import 'package:talonflow/features/home/ui/screens/home_screen.dart';

final router = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ShellScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
