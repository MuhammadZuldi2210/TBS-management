// import dio
import '../../../core/api/dio_client.dart';

class AuthService {
  // login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // request login
    final response = await DioClient.dio.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );

    return response.data;
  }

  // daftar admin
  Future<List<dynamic>> getAdmins() async {
    // request admin
    final response = await DioClient.dio.get("/auth/admins");

    return response.data["data"];
  }

  // profile
  Future<Map<String, dynamic>> getProfile() async {
    // request profile
    final response = await DioClient.dio.get("/auth/profile");

    return response.data;
  }
}
