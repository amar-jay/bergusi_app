import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class CustomTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD32F2F),
          secondary: Color(0xFFFF5252),
          tertiary: Color(0xFFFFCDD2),
          surface: Color(0xFFFAFAFA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD32F2F),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            color: Colors.black,
          ),
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1036242780.
          titleLarge: TextStyle(
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
          ),
        )
        // ... other light theme properties
        );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF5252),
        secondary: Color(0xFFD32F2F),
        tertiary: Color(0xFF7F0000),
        surface: Color(0xFF121212),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5252),
          foregroundColor: Colors.white,
        ),
      ),
      // ... other dark theme properties
    );
  }
}
