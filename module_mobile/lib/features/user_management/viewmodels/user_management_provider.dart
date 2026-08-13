// import flutter material
import 'package:flutter/material.dart';

// import user management service
import '../services/user_management_service.dart';

// Import auth provider
import '../../auth/viewmodels/auth_provider.dart';

// Import dio
import 'package:dio/dio.dart';

// Class provider untuk mengelola state user
class UserManagementProvider extends ChangeNotifier {
  // instance service
  final UserManagementService _userService = UserManagementService();

  // daftar user
  List<dynamic> userList = [];

  // loading
  bool isLoading = false;

  // pesan error
  String? errorMessage;

  // pesan sukses
  String? successMessage;

  // ==========================
  // GET USERS
  // ==========================

  Future<void> getUsers({int page = 1, int limit = 30}) async {
    isLoading = true;

    errorMessage = null;

    notifyListeners();

    try {
      userList = await _userService.getUsers(page: page, limit: limit);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  // ==========================
  // CREATE USER
  // ==========================

  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      isLoading = true;

      errorMessage = null;

      successMessage = null;

      notifyListeners();

      await _userService.createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      successMessage = "User berhasil dibuat";

      // refresh daftar user
      await getUsers();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // ==========================
  // UPDATE USER
  // ==========================

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _userService.updateUser(userId, data);

      successMessage = "User berhasil diperbarui";

      await getUsers();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // TRANSFER USER
  // ==========================

  Future<void> transferUser(String userId, String newOwnerId) async {
    try {
      await _userService.transferUser(userId, newOwnerId);

      successMessage = "User berhasil dipindahkan";

      await getUsers();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // NONAKTIF USER
  // ==========================

  Future<void> deactivateUser(String userId) async {
    try {
      await _userService.deactivateUser(userId);

      successMessage = "User berhasil dinonaktifkan";

      await getUsers();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // AKTIFKAN USER
  // ==========================

  Future<void> activateUser(String userId) async {
    try {
      await _userService.activateUser(userId);

      successMessage = "User berhasil diaktifkan";

      await getUsers();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // SUSPEND USER
  // ==========================

  Future<void> suspendUser(String userId, String reason) async {
    try {
      await _userService.suspendUser(userId, reason);

      successMessage = "User berhasil disuspend";

      await getUsers();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // AKTIFKAN SUSPEND
  // ==========================

  Future<void> activateSuspend(String userId) async {
    try {
      await _userService.activateSuspendUser(userId);

      successMessage = "Suspend user berhasil dibuka";

      await getUsers();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // PERPANJANG MODUL USER
  // ==========================

  Future extendModule(
    String userId,
    int days,
    AuthProvider authProvider,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      // Perpanjang modul
      // Backend juga akan mengurangi coin
      await _userService.extendModule(userId, days);

      // Ambil profile terbaru
      // agar coinBalance langsung berubah
      await authProvider.refreshProfile();

      successMessage = "Modul user berhasil diperpanjang";

      // Refresh daftar user
      await getUsers();

      isLoading = false;

      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;

      if (e is DioException) {
        final data = e.response?.data;

        if (data is Map && data["message"] != null) {
          errorMessage = data["message"].toString();
        } else {
          errorMessage = "Gagal memperpanjang modul";
        }
      } else {
        errorMessage = "Gagal memperpanjang modul";
      }

      notifyListeners();

      return false;
    }
  }

  // ==========================
  // GET MY USERS
  // ==========================

  Future<void> getMyUsers({int page = 1, int limit = 10}) async {
    isLoading = true;

    errorMessage = null;

    notifyListeners();

    try {
      userList = await _userService.getMyUsers(page: page, limit: limit);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  // ==========================
  // CARI USER BERDASARKAN EMAIL
  // ==========================

  dynamic findUserByEmail(String email) {
    try {
      return userList.firstWhere(
        (user) =>
            (user["email"] ?? "").toString().toLowerCase().trim() ==
            email.toLowerCase().trim(),
      );
    } catch (e) {
      return null;
    }
  }
}
