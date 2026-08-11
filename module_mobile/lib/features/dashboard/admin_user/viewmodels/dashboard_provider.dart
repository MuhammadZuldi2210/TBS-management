// import flutter
import 'package:flutter/material.dart';

// import dashboard service
import '../services/dashboard_service.dart';

// Provider Dashboard Admin
class AdminDashboardProvider extends ChangeNotifier {
  // Service
  final DashboardService _service = DashboardService();

  // Loading
  bool isLoading = false;

  // Error
  String? errorMessage;

  // Data dashboard
  Map<String, dynamic> stats = {};

  // Ambil statistik dashboard
  Future<void> getDashboardStats() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      stats = await _service.getAdminStats();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Getter
  int get totalResellers => stats["totalResellers"] ?? 0;

  int get totalDirectUsers => stats["totalDirectUsers"] ?? 0;

  int get totalResellerUsers => stats["totalResellerUsers"] ?? 0;

  int get totalUsers => stats["totalUsers"] ?? 0;

  int get activeUsers => stats["activeUsers"] ?? 0;

  int get expiredUsers => stats["expiredUsers"] ?? 0;

  int get pendingUsers => stats["pendingUsers"] ?? 0;

  int get totalTransactions => stats["totalTransactions"] ?? 0;

  int get pendingTransactions => stats["pendingTransactions"] ?? 0;

  int get approvedTransactions => stats["approvedTransactions"] ?? 0;

  int get rejectedTransactions => stats["rejectedTransactions"] ?? 0;

  int get coinBalance => stats["coinBalance"] ?? 0;

  double get totalRevenue => (stats["totalRevenue"] ?? 0).toDouble();
}
