// import dio client
import '../../../core/api/dio_client.dart';

// Class service untuk mengambil data profile
class ProfileService {
  // mengambil profile user yang sedang login
  Future<Map<String, dynamic>> getProfile() async {
    final response = await DioClient.dio.get("/auth/profile");

    return response.data["user"];
  }

  // update profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final response = await DioClient.dio.put(
      "/auth/profile",
      data: {"name": name, "email": email, "phone": phone},
    );

    return response.data;
  }

  // ubah password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await DioClient.dio.put(
      "/auth/change-password",
      data: {"oldPassword": oldPassword, "newPassword": newPassword},
    );

    return response.data;
  }
}
