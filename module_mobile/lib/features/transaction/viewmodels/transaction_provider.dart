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
  // PAGINATION
  // ==========================

  int currentPage = 1;

  final int pageLimit = 10;

  bool hasNextPage = false;

  // ==========================
  // GET TRANSACTIONS
  // ==========================

  Future<void> getTransactions({
    String? type,
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    isLoading = true;

    errorMessage = null;

    notifyListeners();

    try {
      final data = await _service.getTransactions(
        type: type,
        status: status,
        page: page,
        limit: limit,
      );

      transactionList = data;

      // Simpan filter aktif
      selectedType = type;
      selectedStatus = status;

      // Simpan halaman sekarang
      currentPage = page;

      // Kalau data yang diterima sebanyak limit,
      // kemungkinan masih ada halaman berikutnya.
      hasNextPage = data.length == limit;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  // ==========================
  // NEXT PAGE
  // ==========================

  Future<void> nextPage() async {
    if (!hasNextPage || isLoading) {
      return;
    }

    await getTransactions(
      type: selectedType,
      status: selectedStatus,
      page: currentPage + 1,
      limit: pageLimit,
    );
  }

  // ==========================
  // PREVIOUS PAGE
  // ==========================

  Future<void> previousPage() async {
    if (currentPage <= 1 || isLoading) {
      return;
    }

    await getTransactions(
      type: selectedType,
      status: selectedStatus,
      page: currentPage - 1,
      limit: pageLimit,
    );
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

      await authProvider.refreshProfile();

      // ==================================
      // REFRESH TRANSAKSI
      // ==================================

      await getTransactions(
        type: selectedType,
        status: selectedStatus,
        page: currentPage,
        limit: pageLimit,
      );

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

    currentPage = 1;

    hasNextPage = false;

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

    currentPage = 1;

    await getTransactions(page: 1, limit: pageLimit);
  }
}
