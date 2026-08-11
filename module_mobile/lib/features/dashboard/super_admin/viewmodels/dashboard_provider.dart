// import flutter material
import 'package:flutter/material.dart';

// import dashboard service
import '../services/dashboard_service.dart';

// provider dashboard
class DashboardProvider extends ChangeNotifier {
  // instance service
  final DashboardService _service = DashboardService();

  // data statistik
  Map<String, dynamic> stats = {};

  // loading
  bool isLoading = false;

  // pesan error
  String? errorMessage;

  // mengambil statistik
  Future<void> getStats() async {
    // mulai loading
    isLoading = true;

    notifyListeners();

    try {
      // ambil data dari service
      stats = await _service.getStats();
    } catch (e) {
      // simpan error
      errorMessage = e.toString();
    }

    // selesai loading
    isLoading = false;

    notifyListeners();
  }
}
