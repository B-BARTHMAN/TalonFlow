import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seedColor = Color.fromARGB(255, 7, 85, 137);

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
  );
}
