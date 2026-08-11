// import flutter material
import 'package:flutter/material.dart';

// import profile service
import '../services/profile_service.dart';

// Provider untuk mengelola data profile
class ProfileProvider extends ChangeNotifier {
  // instance service
  final ProfileService _profileService = ProfileService();

  // data profile
  Map<String, dynamic>? profile;

  // loading
  bool isLoading = false;

  // error message
  String? errorMessage;
  String? successMessage;

  // mengambil profile
  Future<void> getProfile() async {
    // mulai loading
    isLoading = true;

    // reset error
    errorMessage = null;

    notifyListeners();

    try {
      // ambil data profile
      profile = await _profileService.getProfile();
    } catch (e) {
      // simpan error
      errorMessage = e.toString();
    }

    // selesai loading
    isLoading = false;

    notifyListeners();
  }

  // update profile
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      final response = await _profileService.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );

      successMessage = response["message"];

      await getProfile();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ubah password
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    notifyListeners();

    try {
      final response = await _profileService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      successMessage = response["message"];

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
