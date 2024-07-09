import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Color.fromARGB(255, 33, 33, 33),
    tertiary: Color.fromARGB(255, 221, 221, 221),
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color.fromARGB(255, 33, 33, 33),
    secondary: const Color.fromARGB(255, 255, 255, 255),
    tertiary: Color.fromARGB(255, 24, 24, 24),
  )
);
