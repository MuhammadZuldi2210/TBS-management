// import flutter material
import 'package:flutter/material.dart';

// import admin service
import '../services/admin_service.dart';

// Class provider untuk mengelola state admin
class AdminProvider extends ChangeNotifier {
  // instance admin service
  final AdminService _adminService = AdminService();

  // daftar admin
  List adminList = [];

  // daftar reseller milik admin
  List resellerList = [];

  // loading
  bool isLoading = false;

  // pesan error
  String? errorMessage;

  // pesan sukses
  String? successMessage;

  // ==========================================
  // MENGAMBIL DAFTAR ADMIN
  // ==========================================
  Future getAdmins() async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      adminList = await _adminService.getAdmins();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // MENAMBAHKAN ADMIN
  // ==========================================
  Future createAdmin({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      final response = await _adminService.createAdmin(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      successMessage = response["message"];

      await getAdmins();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // UPDATE ADMIN
  // ==========================================
  Future updateAdmin({
    required String id,
    required String name,
    required String email,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      final response = await _adminService.updateAdmin(
        id: id,
        name: name,
        email: email,
      );

      successMessage = response["message"];

      await getAdmins();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // NONAKTIFKAN ADMIN
  // ==========================================
  Future deactivateAdmin(String id) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      await _adminService.deactivateAdmin(id);

      successMessage = "Admin berhasil dinonaktifkan";

      await getAdmins();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // AKTIFKAN ADMIN
  // ==========================================
  Future activateAdmin(String id) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      await _adminService.activateAdmin(id);

      successMessage = "Admin berhasil diaktifkan";

      await getAdmins();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // SUSPEND ADMIN
  // ==========================================
  Future suspendAdmin({required String id, String? reason}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      // Kirim request suspend ke backend
      await _adminService.suspendAdmin(id: id, reason: reason);

      // Refresh daftar admin setelah backend berhasil
      await getAdmins();

      successMessage = "Admin berhasil disuspend";

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // AKTIFKAN KEMBALI ADMIN YANG DISUSPEND
  // ==========================================
  Future activateSuspend(String id) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      // Kirim request activate suspend
      await _adminService.activateSuspend(id);

      // Refresh daftar admin
      await getAdmins();

      successMessage = "Admin berhasil diaktifkan kembali";

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // MENGAMBIL RESELLER MILIK ADMIN
  // ==========================================
  Future getAdminResellers(String adminId) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      resellerList = await _adminService.getAdminResellers(adminId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
