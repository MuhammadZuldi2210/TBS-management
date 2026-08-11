// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth provider
import '../auth/viewmodels/auth_provider.dart';

// import navigation
import '../navigation/views/super_admin_navigation.dart';
import '../navigation/views/admin_user_navigation.dart';
import '../navigation/views/reseller_navigation.dart';

// Dashboard Page
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // ==========================================
    // SUPER ADMIN
    // ==========================================
    if (auth.role == "super_admin") {
      return const SuperAdminNavigation();
    }

    // ==========================================
    // ADMIN USER
    // ==========================================
    if (auth.role == "admin_user") {
      return const AdminUserNavigation();
    }

    // ==========================================
    // RESELLER
    // ==========================================
    if (auth.role == "reseller") {
      return const ResellerNavigation();
    }

    // ==========================================
    // ROLE TIDAK DIKENALI
    // ==========================================
    return const Scaffold(body: Center(child: Text("Role tidak dikenali")));
  }
}
