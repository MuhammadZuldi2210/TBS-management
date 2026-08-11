// import flutter material
import 'package:flutter/material.dart';

// Theme khusus halaman Login & Register
class AuthTheme {
  AuthTheme._();

  // Background utama
  static const Color background = Color(0xFF050816);

  // Warna card
  static const Color cardBackground = Color(0xFF0B1023);

  // Warna border
  static const Color border = Color(0xFF2A4B9B);

  // Warna glow
  static const Color blueGlow = Color(0xFF00C8FF);
  static const Color purpleGlow = Color(0xFF6C63FF);

  // Warna tombol
  static const Color buttonBlue = Color(0xFF009DFF);
  static const Color buttonPink = Color(0xFFFF2FA5);

  // Gradient tombol
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [buttonBlue, buttonPink],
  );

  // Warna text
  static const Color title = Colors.white;
  static const Color subtitle = Color(0xFFB7BED1);

  // Warna input
  static const Color inputFill = Color(0xFF141A31);
  static const Color hint = Color(0xFF8088A3);
}
