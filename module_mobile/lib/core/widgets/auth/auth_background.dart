// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// Widget background halaman autentikasi
class AuthBackground extends StatelessWidget {
  // Widget yang akan ditampilkan di atas background
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.background,

      body: Stack(
        children: [
          // Glow biru kiri atas
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AuthTheme.blueGlow.withOpacity(0.18),
              ),
            ),
          ),

          // Glow ungu kanan bawah
          Positioned(
            bottom: -140,
            right: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AuthTheme.purpleGlow.withOpacity(0.18),
              ),
            ),
          ),

          // Konten halaman
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
