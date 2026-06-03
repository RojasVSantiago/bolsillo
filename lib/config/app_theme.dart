import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF1D9E75);
  static const _primaryLight = Color(0xFFE1F5EE);
  static const _primaryDark = Color(0xFF085041);

  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        primary: _primary,
        onPrimary: _primaryLight,
        primaryContainer: _primaryLight,
        onPrimaryContainer: _primaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primary,
        foregroundColor: _primaryLight,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primary,
        foregroundColor: _primaryLight,
      ),
      cardTheme: const CardThemeData(
        color: _primaryLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      useMaterial3: true,
    );
  }
}
