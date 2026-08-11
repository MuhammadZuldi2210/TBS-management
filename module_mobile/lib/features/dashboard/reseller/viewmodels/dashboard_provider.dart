// import flutter
import 'package:flutter/material.dart';

// import dashboard service
import '../services/dashboard_service.dart';

// Provider Dashboard Reseller
class ResellerDashboardProvider extends ChangeNotifier {
  // Service
  final DashboardService _service = DashboardService();

  // Loading
  bool isLoading = false;

  // Error
  String? errorMessage;

  // Data dashboard
  Map<String, dynamic> stats = {};

  // Ambil statistik dashboard reseller
  Future<void> getDashboardStats() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      stats = await _service.getResellerStats();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // GETTER
  // ==============================

  // Total user
  int get totalUsers => stats["totalUsers"] ?? 0;

  // User aktif
  int get activeUsers => stats["activeUsers"] ?? 0;

  // User expired
  int get expiredUsers => stats["expiredUsers"] ?? 0;

  // User pending
  int get pendingUsers => stats["pendingUsers"] ?? 0;

  // Saldo coin
  int get coinBalance => stats["coinBalance"] ?? 0;

  // Total transaksi
  int get totalTransactions => stats["totalTransactions"] ?? 0;

  // Transaksi pending
  int get pendingTransactions => stats["pendingTransactions"] ?? 0;

  // Transaksi approved
  int get approvedTransactions => stats["approvedTransactions"] ?? 0;
}
