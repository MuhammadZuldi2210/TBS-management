// Mengimpor package Flutter Secure Storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Class untuk mengelola penyimpanan data yang bersifat rahasia
class SecureStorage {
  // Membuat object Flutter Secure Storage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

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
}
