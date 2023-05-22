import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? const Color.fromARGB(255, 31, 127, 80)
          : const Color.fromARGB(255, 142, 219, 182),
      primaryColor: const Color.fromARGB(255, 31, 127, 80),
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: isDarkTheme
                ? const Color.fromARGB(255, 74, 177, 127)
                : const Color.fromARGB(255, 142, 219, 182),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 31, 127, 80)
          : const Color.fromARGB(255, 142, 219, 182),
      canvasColor: isDarkTheme
          ? const Color.fromARGB(255, 46, 165, 108)
          : const Color.fromARGB(255, 51, 201, 129),
      appBarTheme: AppBarTheme(
          backgroundColor: isDarkTheme
              ? Color.fromARGB(138, 139, 142, 140)
              : const Color.fromARGB(255, 6, 118, 75)),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
    );
  }
}
