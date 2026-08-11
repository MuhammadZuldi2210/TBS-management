// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// Card utama halaman Login & Register
class AuthCard extends StatelessWidget {
  // Widget di dalam card
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 430),

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: AuthTheme.cardBackground,

        borderRadius: BorderRadius.circular(28),

        border: Border.all(color: AuthTheme.border, width: 1.5),

        boxShadow: [
          // Glow biru
          BoxShadow(
            color: AuthTheme.blueGlow.withOpacity(0.18),
            blurRadius: 30,
            spreadRadius: 1,
          ),

          // Glow ungu
          BoxShadow(
            color: AuthTheme.purpleGlow.withOpacity(0.08),
            blurRadius: 45,
            spreadRadius: 2,
          ),
        ],
      ),

      child: child,
    );
  }
}
