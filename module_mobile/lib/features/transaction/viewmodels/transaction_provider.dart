// import flutter material
import 'package:flutter/material.dart';

// Import dio
import 'package:dio/dio.dart';

// import transaction service
import '../services/transaction_service.dart';

// import auth provider
import '../../auth/viewmodels/auth_provider.dart';

// Provider transaksi
class TransactionProvider extends ChangeNotifier {
  // instance service
  final TransactionService _service = TransactionService();

  // list transaksi
  List transactionList = [];

  // loading
  bool isLoading = false;

  // error
  String? errorMessage;

  // filter aktif
  String? selectedType;

  String? selectedStatus;

  // ==========================
  // GET TRANSACTIONS
  // ==========================

  Future getTransactions({String? type, String? status}) async {
    isLoading = true;

    errorMessage = null;

    notifyListeners();

    try {
      transactionList = await _service.getTransactions(
        type: type,
        status: status,
      );

      // simpan filter aktif
      selectedType = type;
      selectedStatus = status;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  // ==========================
  // APPROVE TRANSACTION
  // ==========================

  Future approveTransaction(String id, AuthProvider authProvider) async {
    try {
      errorMessage = null;

      // ==================================
      // APPROVE DI BACKEND
      // ==================================

      await _service.approveTransaction(id);

      // ==================================
      // REFRESH PROFILE
      // ==================================
      // Mengambil coinBalance terbaru
      // dari backend.
      //
      // Jadi Admin / Reseller tidak perlu
      // pindah tab atau reload dashboard.
      // ==================================

      await authProvider.refreshProfile();

      // ==================================
      // REFRESH TRANSAKSI
      // ==================================

      await getTransactions(type: selectedType, status: selectedStatus);

      return true;
    } catch (e) {
      if (e is DioException) {
        errorMessage = e.response?.data["message"] ?? "Gagal approve transaksi";
      } else {
        errorMessage = "Gagal approve transaksi";
      }

      notifyListeners();

      return false;
    }
  }

  // ==========================
  // CLEAR TRANSACTION STATE
  // ==========================

  void clearTransactions() {
    transactionList = [];
    selectedType = null;
    selectedStatus = null;
    isLoading = false;
    errorMessage = null;

    notifyListeners();
  }

  // ==========================
  // RESET FILTER
  // ==========================

  Future resetFilter() async {
    selectedType = null;

    selectedStatus = null;

    await getTransactions();
  }
}
