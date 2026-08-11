// Import material flutter
import 'package:flutter/material.dart';
// Import halaman kamu
import '../features/dashboard/dashboard_page.dart';
// Import halaman login
import '../features/auth/views/login_page.dart';
// Import Splash Screen
import '../features/auth/views/splash_page.dart';

class AppRoutes {
  // route awal
  static const String initial = '/';

  // semua route aplikasi
  static Map<String, WidgetBuilder> routes = {
    // SPLASH SCREEN
    '/': (context) => const SplashPage(),

    // LOGIN
    '/login': (context) => LoginPage(),

    // DASHBOARD
    '/dashboard': (context) => DashboardPage(),
  };
}
