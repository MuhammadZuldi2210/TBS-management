// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// Widget Card Statistik Dashboard
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuthTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AuthTheme.border),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 16),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              color: AuthTheme.title,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AuthTheme.subtitle, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
