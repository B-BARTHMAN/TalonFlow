import 'package:flutter/material.dart';
import 'package:talonflow/config/routing/router.dart';
import 'package:talonflow/config/theme/app_theme.dart';

class TalonFlowApp extends StatelessWidget {
  const TalonFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TalonFlow',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
