import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color secondaryColor = Color(0xFFFF9500);
  static const Color backgroundColor = Color(0xFFF2F2F7);
  static const Color gradientStartColor = Color(0xFF4B9FE1);
  static const Color gradientEndColor = Color(0xFF87CEEB);
  static const Color textColor = Color(0xFF000000);
  static const Color subtitleColor = Color(0xFF8E8E93);
  static const Color cardColor = Colors.white;
  static const Color buttonColor = Color(0xFFFF5A5F);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: const TextStyle(color: textColor),
        displayMedium: const TextStyle(color: textColor),
        displaySmall: const TextStyle(color: textColor),
        headlineLarge: const TextStyle(color: textColor),
        headlineMedium: const TextStyle(color: textColor),
        headlineSmall: const TextStyle(color: textColor),
        titleLarge: const TextStyle(color: textColor),
        titleMedium: const TextStyle(color: textColor),
        titleSmall: const TextStyle(color: textColor),
        bodyLarge: const TextStyle(color: textColor),
        bodyMedium: const TextStyle(color: textColor),
        bodySmall: const TextStyle(color: subtitleColor),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
      ),
    );
  }
}
