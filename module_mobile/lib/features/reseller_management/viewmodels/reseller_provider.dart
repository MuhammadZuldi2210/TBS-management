// import flutter material
import 'package:flutter/material.dart';

// import reseller service
import '../services/reseller_service.dart';

// Provider untuk mengelola data reseller
class ResellerProvider extends ChangeNotifier {
  // instance service
  final ResellerService _resellerService = ResellerService();

  // daftar reseller
  List<dynamic> resellerList = [];

  // daftar user milik reseller
  List<dynamic> resellerUserList = [];

  // loading
  bool isLoading = false;

  // pesan error
  String? errorMessage;

  // pesan sukses
  String? successMessage;

  // ==============================
  // GET MY RESELLERS
  // ==============================

  Future<void> getMyResellers() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      // ambil data reseller
      resellerList = await _resellerService.getMyResellers();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // ==============================
  // CREATE RESELLER
  // ==============================

  Future<bool> createReseller({
    required String name,

    required String email,

    required String password,

    String? phone,
  }) async {
    try {
      isLoading = true;

      errorMessage = null;

      successMessage = null;

      notifyListeners();

      // kirim request create reseller
      await _resellerService.createReseller(
        name: name,

        email: email,

        password: password,

        phone: phone,
      );

      successMessage = "Reseller berhasil dibuat";

      // refresh daftar reseller
      await getMyResellers();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // ==============================
  // GET USER RESELLER
  // ==============================

  Future<void> getResellerUsers(
    String resellerId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // mulai loading
      isLoading = true;

      // reset error
      errorMessage = null;

      notifyListeners();

      // ambil user reseller dari service
      resellerUserList = await _resellerService.getResellerUsers(
        resellerId,
        page: page,
        limit: limit,
      );
    } catch (e) {
      // simpan error
      errorMessage = e.toString();
    } finally {
      // selesai loading
      isLoading = false;

      notifyListeners();
    }
  }

  // ==============================
  // UPDATE RESELLER
  // ==============================

  Future<bool> updateReseller({
    required String resellerId,
    required String name,
    String? phone,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;

      notifyListeners();

      await _resellerService.updateReseller(
        resellerId: resellerId,
        name: name,
        phone: phone,
      );

      successMessage = "Reseller berhasil diperbarui";

      await getMyResellers();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // SUSPEND RESELLER
  // ==============================

  Future<bool> suspendReseller({
    required String resellerId,
    required String reason,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;

      notifyListeners();

      await _resellerService.suspendReseller(
        resellerId: resellerId,
        reason: reason,
      );

      successMessage = "Reseller berhasil disuspend";

      return true;
    } catch (e) {
      errorMessage = e.toString();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // DEACTIVATE RESELLER
  // ==============================

  Future<bool> deactivateReseller(String resellerId) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;

      notifyListeners();

      await _resellerService.deactivateReseller(resellerId);

      successMessage = "Reseller berhasil dinonaktifkan";

      await getMyResellers();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // ACTIVATE RESELLER
  // ==============================

  Future<bool> activateReseller(String resellerId) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;

      notifyListeners();

      await _resellerService.activateReseller(resellerId);

      successMessage = "Reseller berhasil diaktifkan";

      await getMyResellers();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // GET ALL RESELLERS
  // SUPER ADMIN
  // ==============================

  Future<void> getAllResellers() async {
    try {
      isLoading = true;

      errorMessage = null;

      notifyListeners();

      resellerList = await _resellerService.getAllResellers();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
