// Mengimpor package Flutter Secure Storage
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Class untuk mengelola penyimpanan data yang bersifat rahasia
class SecureStorage {
  // Membuat object Flutter Secure Storage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ==========================================================
  // TOKEN
  // ==========================================================

  // Key untuk menyimpan token
  static const String tokenKey = "token";

  // Menyimpan token ke Secure Storage
  static Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  // Mengambil token dari Secure Storage
  static Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  // Menghapus token dari Secure Storage
  static Future<void> deleteToken() async {
    await _storage.delete(key: tokenKey);
  }

  // ==========================================================
  // AKUN LOGIN TERSIMPAN
  // ==========================================================

  // Key untuk menyimpan daftar akun
  static const String savedAccountsKey = "saved_accounts";

  // ==========================================================
  // SIMPAN AKUN
  // ==========================================================

  static Future<void> saveAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Ambil akun yang sudah tersimpan
      final accounts = await getSavedAccounts();

      // Cek apakah email sudah pernah tersimpan
      final existingIndex = accounts.indexWhere(
        (account) =>
            account["email"]?.toString().toLowerCase() == email.toLowerCase(),
      );

      final accountData = {"name": name, "email": email, "password": password};

      if (existingIndex >= 0) {
        // Kalau sudah ada, update akun tersebut
        accounts[existingIndex] = accountData;
      } else {
        // Kalau belum ada, tambahkan akun baru
        accounts.add(accountData);
      }

      // Simpan kembali ke Secure Storage
      await _storage.write(key: savedAccountsKey, value: jsonEncode(accounts));
    } catch (e) {
      // Jangan sampai error penyimpanan membuat login gagal
      print("SAVE ACCOUNT ERROR: $e");
    }
  }

  // ==========================================================
  // AMBIL SEMUA AKUN
  // ==========================================================

  static Future<List<Map<String, dynamic>>> getSavedAccounts() async {
    try {
      final data = await _storage.read(key: savedAccountsKey);

      if (data == null || data.isEmpty) {
        return [];
      }

      final decoded = jsonDecode(data);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .map((account) => Map<String, dynamic>.from(account))
          .toList();
    } catch (e) {
      print("GET SAVED ACCOUNTS ERROR: $e");

      return [];
    }
  }

  // ==========================================================
  // HAPUS AKUN TERTENTU
  // ==========================================================

  static Future<void> deleteSavedAccount(String email) async {
    try {
      final accounts = await getSavedAccounts();

      accounts.removeWhere(
        (account) =>
            account["email"]?.toString().toLowerCase() == email.toLowerCase(),
      );

      await _storage.write(key: savedAccountsKey, value: jsonEncode(accounts));
    } catch (e) {
      print("DELETE SAVED ACCOUNT ERROR: $e");
    }
  }

  // ==========================================================
  // HAPUS SEMUA AKUN
  // ==========================================================

  static Future<void> deleteAllSavedAccounts() async {
    await _storage.delete(key: savedAccountsKey);
  }
}
