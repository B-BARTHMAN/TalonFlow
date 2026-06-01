import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talonflow/config/routing/routes.dart';
import 'package:talonflow/config/routing/shell.dart';
import 'package:talonflow/core/repositories/diagram_repository.dart';
import 'package:talonflow/features/editor/cubit/diagram_editor_cubit.dart';
import 'package:talonflow/features/editor/ui/screens/entity_detail_screen.dart';
import 'package:talonflow/features/home/ui/screens/home_screen.dart';

final router = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => BlocProvider(
        create: (context) =>
            DiagramEditorCubit(repository: context.read<DiagramRepository>()),
        child: ShellScaffold(navigationShell: navigationShell),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: Routes.entity,
                  builder: (context, state) => EntityDetailScreen(
                    entityId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
