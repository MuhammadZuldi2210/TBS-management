// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// Widget Judul Section Dashboard
class DashboardSectionTitle extends StatelessWidget {
  // judul
  final String title;

  // icon (opsional)
  final IconData? icon;

  const DashboardSectionTitle({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // icon
        if (icon != null) ...[
          Icon(icon, color: AuthTheme.blueGlow, size: 22),
          const SizedBox(width: 8),
        ],

        // judul
        Text(
          title,
          style: const TextStyle(
            color: AuthTheme.title,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
