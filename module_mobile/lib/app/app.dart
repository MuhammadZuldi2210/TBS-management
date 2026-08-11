// flutter material
import 'package:flutter/material.dart';

// routes
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner DEBUG
      debugShowCheckedModeBanner: false,

      // Halaman pertama aplikasi
      initialRoute: "/",

      // Mendaftarkan semua route aplikasi
      routes: AppRoutes.routes,
    );
  }
}
