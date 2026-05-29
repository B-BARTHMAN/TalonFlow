import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seedColor = Color.fromARGB(255, 7, 85, 137);

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor, 
      brightness: Brightness.dark
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor)
  );
}
