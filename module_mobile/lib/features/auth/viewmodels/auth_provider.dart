// import flutter foundation
import 'package:flutter/foundation.dart';

// auth service
import '../services/auth_service.dart';

// secure storage
import '../../../core/storage/secure_storage.dart';

// import dio
import 'package:dio/dio.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // ==========================================
  // STATE
  // ==========================================

  bool _isLoading = false;
  bool _isLoggedIn = false;

  String? _name;
  String? _ownerId;
  String? _email;
  String? _phone;
  String? _token;
  String? _role;
  String? _userId;

  String? _errorMessage;
  String? _successMessage;

  bool _isModuleExpired = false;
  int _coinBalance = 0;

  List _admins = [];

  // ==========================================
  // AKUN TERSIMPAN
  // ==========================================

  List<Map<String, dynamic>> _savedAccounts = [];

  // ==========================================
  // GETTER
  // ==========================================

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _isLoggedIn;

  String? get ownerId => _ownerId;

  String? get name => _name;

  String? get email => _email;

  String? get phone => _phone;

  String? get token => _token;

  String? get role => _role;

  String? get userId => _userId;

  String? get errorMessage => _errorMessage;

  String? get successMessage => _successMessage;

  List get admins => _admins;

  bool get isModuleExpired => _isModuleExpired;

  int get coinBalance => _coinBalance;

  // Getter akun tersimpan
  List<Map<String, dynamic>> get savedAccounts => _savedAccounts;

  // ==========================================
  // LOGIN
  // ==========================================

  Future login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;

    notifyListeners();

    try {
      // ==========================================
      // REQUEST LOGIN
      // ==========================================

      final data = await _authService.login(email: email, password: password);

      // ==========================================
      // TOKEN
      // ==========================================

      _token = data["token"];

      // ==========================================
      // USER DATA
      // ==========================================

      final user = data["user"];

      // User ID
      _userId = user["_id"]?.toString();

      // Role
      _role = user["role"];

      // Owner ID
      _ownerId = user["ownerId"]?.toString();

      // Nama
      _name = user["name"];

      // Email
      _email = user["email"];

      // Phone
      _phone = user["phone"];

      // Coin
      _coinBalance = user["coinBalance"] ?? 0;

      // ==========================================
      // CEK MODUL EXPIRED
      // ==========================================

      final expiredAt = user["moduleExpiredAt"];

      if (expiredAt != null) {
        _isModuleExpired = DateTime.parse(expiredAt).isBefore(DateTime.now());

        debugPrint("MODULE EXPIRED: $_isModuleExpired");
      } else {
        _isModuleExpired = false;
      }

      // ==========================================
      // SIMPAN TOKEN
      // ==========================================

      await SecureStorage.saveToken(_token!);

      // ==========================================
      // SIMPAN AKUN LOGIN
      // ==========================================

      await SecureStorage.saveAccount(
        name: _name ?? "Pengguna",
        email: _email ?? email,
        password: password,
      );

      // ==========================================
      // UPDATE DAFTAR AKUN
      // ==========================================

      await loadSavedAccounts();

      _isLoggedIn = true;
    } catch (e) {
      _isLoggedIn = false;

      _token = null;
      _role = null;
      _ownerId = null;

      if (e is DioException) {
        _errorMessage = e.response?.data["message"] ?? "Login gagal";
      } else {
        _errorMessage = "Login gagal";
      }

      debugPrint("LOGIN ERROR DETAIL: ${e.toString()}");
    }

    _isLoading = false;

    notifyListeners();
  }

  // ==========================================
  // LOAD AKUN TERSIMPAN
  // ==========================================

  Future<void> loadSavedAccounts() async {
    _savedAccounts = await SecureStorage.getSavedAccounts();

    notifyListeners();
  }

  // ==========================================
  // HAPUS AKUN TERSIMPAN
  // ==========================================

  Future<void> removeSavedAccount(String email) async {
    await SecureStorage.deleteSavedAccount(email);

    await loadSavedAccounts();
  }

  // ==========================================
  // AMBIL DAFTAR ADMIN
  // ==========================================

  Future loadAdmins() async {
    try {
      _admins = await _authService.getAdmins();

      notifyListeners();
    } catch (e) {
      debugPrint("LOAD ADMINS ERROR: $e");
    }
  }

  // ==========================================
  // REFRESH PROFILE
  // ==========================================

  Future refreshProfile() async {
    try {
      final response = await _authService.getProfile();

      if (response["success"] == true) {
        final user = response["user"];

        _userId = user["_id"]?.toString();

        _role = user["role"];

        _ownerId = user["ownerId"]?.toString();

        _name = user["name"];

        _email = user["email"];

        _phone = user["phone"];

        _coinBalance = user["coinBalance"] ?? 0;

        final expiredAt = user["moduleExpiredAt"];

        if (expiredAt != null) {
          _isModuleExpired = DateTime.parse(expiredAt).isBefore(DateTime.now());
        } else {
          _isModuleExpired = false;
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint("REFRESH PROFILE ERROR: $e");
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  Future logout() async {
    // ==========================================
    // HAPUS TOKEN SAJA
    // ==========================================
    //
    // AKUN TERSIMPAN TIDAK DIHAPUS.
    // Jadi setelah logout email dan password
    // masih tersedia di halaman login.

    await SecureStorage.deleteToken();

    // ==========================================
    // RESET STATE
    // ==========================================

    _isLoggedIn = false;

    _token = null;

    _role = null;

    _userId = null;

    _ownerId = null;

    _name = null;

    _email = null;

    _phone = null;

    _coinBalance = 0;

    _isModuleExpired = false;

    _errorMessage = null;

    _successMessage = null;

    // Pastikan akun tersimpan tetap tersedia
    await loadSavedAccounts();

    notifyListeners();
  }

  // ==========================================
  // CEK LOGIN
  // ==========================================

  Future initAuth() async {
    try {
      // ==========================================
      // LOAD AKUN TERSIMPAN
      // ==========================================

      await loadSavedAccounts();

      // ==========================================
      // AMBIL TOKEN
      // ==========================================

      final storedToken = await SecureStorage.getToken();

      if (storedToken == null) {
        _isLoggedIn = false;

        notifyListeners();

        return;
      }

      _token = storedToken;

      // ==========================================
      // AMBIL PROFILE
      // ==========================================

      final response = await _authService.getProfile();

      if (response["success"] == true) {
        final user = response["user"];

        _isLoggedIn = true;

        // User ID
        _userId = user["_id"]?.toString();

        // Role
        _role = user["role"];

        // Owner ID
        _ownerId = user["ownerId"]?.toString();

        // Nama
        _name = user["name"];

        // Email
        _email = user["email"];

        // Phone
        _phone = user["phone"];

        // Coin
        _coinBalance = user["coinBalance"] ?? 0;

        // ==========================================
        // CEK MODUL EXPIRED
        // ==========================================

        final expiredAt = user["moduleExpiredAt"];

        if (expiredAt != null) {
          _isModuleExpired = DateTime.parse(expiredAt).isBefore(DateTime.now());
        } else {
          _isModuleExpired = false;
        }
      } else {
        await logout();
      }
    } catch (e) {
      // Jangan hapus akun tersimpan.
      await SecureStorage.deleteToken();

      _isLoggedIn = false;

      _token = null;

      debugPrint("INIT AUTH ERROR: $e");
    }

    notifyListeners();
  }
}
