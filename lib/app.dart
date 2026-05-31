import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/config/routing/router.dart';
import 'package:talonflow/config/theme/app_theme.dart';
import 'package:talonflow/core/repositories/diagram_repository.dart';
import 'package:talonflow/core/services/diagram_file_service.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';

class TalonFlowApp extends StatelessWidget {
  const TalonFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => DiagramRepository(service: DiagramFileService()),
      child: BlocProvider(
        create: (context) => DiagramListCubit(
          repository: context.read<DiagramRepository>(),
        )..loadDiagrams(),
        child: MaterialApp.router(
          title: 'TalonFlow',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: router,
        ),
      ),
    );
  }
}
