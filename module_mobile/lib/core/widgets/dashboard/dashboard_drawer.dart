// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// Widget Drawer Dashboard
class DashboardDrawer extends StatelessWidget {
  // nama user
  final String name;

  // role user
  final String role;

  // callback logout
  final VoidCallback onLogout;

  const DashboardDrawer({
    super.key,
    required this.name,
    required this.role,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AuthTheme.background,
      child: SafeArea(
        child: Column(
          children: [
            // header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AuthTheme.cardBackground,
                border: Border(bottom: BorderSide(color: AuthTheme.border)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AuthTheme.blueGlow.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AuthTheme.blueGlow,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AuthTheme.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    role,
                    style: const TextStyle(
                      color: AuthTheme.subtitle,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // dashboard
            _buildMenu(
              icon: Icons.dashboard_rounded,
              title: "Dashboard",
              onTap: () => Navigator.pop(context),
            ),

            // profile
            _buildMenu(
              icon: Icons.person_outline,
              title: "Profile",
              onTap: () {},
            ),

            const Spacer(),

            const Divider(color: AuthTheme.border, height: 1),

            _buildMenu(
              icon: Icons.logout_rounded,
              title: "Logout",
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              onTap: onLogout,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // item menu
  Widget _buildMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AuthTheme.blueGlow,
    Color textColor = AuthTheme.title,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
