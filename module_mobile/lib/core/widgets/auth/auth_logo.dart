// import flutter material
import 'package:flutter/material.dart';

// Widget logo halaman autentikasi
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        // Efek glow di belakang logo
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.25),
            blurRadius: 35,
            spreadRadius: 2,
          ),
        ],
      ),

      child: Image.asset("assets/logos/TBS.png", fit: BoxFit.contain),
    );
  }
}
