import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFFF1F5),
    primary: Color(0xFFFFF8EE),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF1E1E2C),
    primary: Color(0xFF2A2A3D),
  ),
);
