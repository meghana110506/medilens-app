import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0A0F1E);
  static const Color accent = Color(0xFF3B8BEB);
  static const Color teal = Color(0xFF00C9B1);
  static const Color card = Color(0xFF1A2235);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF8A9BB0);
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB300);

  // High contrast colors
  static const Color hcBackground = Color(0xFF000000);
  static const Color hcAccent = Color(0xFF00D4FF);
  static const Color hcTeal = Color(0xFF00FFD4);
  static const Color hcCard = Color(0xFF1A1A1A);
  static const Color hcWhite = Color(0xFFFFFFFF);
  static const Color hcGrey = Color(0xFFCCCCCC);
  static const Color hcError = Color(0xFFFF0000);
  static const Color hcSuccess = Color(0xFF00FF00);
  static const Color hcWarning = Color(0xFFFFFF00);

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: accent,
      fontFamily: 'NotoSans',
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: teal,
        surface: card,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'NotoSans',
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontFamily: 'NotoSans',
            color: white,
            fontSize: 32,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            fontFamily: 'NotoSans',
            color: white,
            fontSize: 24,
            fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            fontFamily: 'NotoSans',
            color: white,
            fontSize: 20,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            fontFamily: 'NotoSans',
            color: white,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        bodyLarge:
            TextStyle(fontFamily: 'NotoSans', color: white, fontSize: 16),
        bodyMedium:
            TextStyle(fontFamily: 'NotoSans', color: grey, fontSize: 14),
      ),
    );
  }

  static ThemeData get highContrastTheme {
    return ThemeData(
      scaffoldBackgroundColor: hcBackground,
      primaryColor: hcAccent,
      fontFamily: 'NotoSans',
      colorScheme: const ColorScheme.dark(
        primary: hcAccent,
        secondary: hcTeal,
        surface: hcCard,
        error: hcError,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: hcBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'NotoSans',
          color: hcWhite,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: hcWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: hcAccent,
          foregroundColor: hcBackground,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: hcWhite, width: 2),
          ),
          textStyle: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: hcCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: hcWhite.withValues(alpha: 0.3), width: 2),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontFamily: 'NotoSans',
            color: hcWhite,
            fontSize: 36,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            fontFamily: 'NotoSans',
            color: hcWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            fontFamily: 'NotoSans',
            color: hcWhite,
            fontSize: 22,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            fontFamily: 'NotoSans',
            color: hcWhite,
            fontSize: 18,
            fontWeight: FontWeight.w500),
        bodyLarge:
            TextStyle(fontFamily: 'NotoSans', color: hcWhite, fontSize: 18),
        bodyMedium:
            TextStyle(fontFamily: 'NotoSans', color: hcGrey, fontSize: 16),
      ),
    );
  }
}
