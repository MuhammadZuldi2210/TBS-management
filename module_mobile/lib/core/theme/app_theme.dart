// import material
import 'package:flutter/material.dart';

// tema global aplikasi
class AppTheme {
  // warna utama aplikasi
  static const Color primaryColor = Color(0xFF4F46E5);

  // warna kedua
  static const Color secondaryColor = Color(0xFF7C3AED);

  // warna aksen
  static const Color accentColor = Color(0xFFEC4899);

  // warna background
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // tema terang aplikasi
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // warna utama
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    // background scaffold
    scaffoldBackgroundColor: backgroundColor,

    // font global
    fontFamily: "Poppins",

    // appbar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
    ),

    // card
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // tombol
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    // input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
  );
}
