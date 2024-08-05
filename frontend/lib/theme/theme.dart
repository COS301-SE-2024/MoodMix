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
    primary: Color.fromARGB(255, 22, 22, 22),
    secondary: const Color.fromARGB(255, 200, 200, 200),
    tertiary: Color.fromARGB(255, 14, 14, 14),
  )
);
