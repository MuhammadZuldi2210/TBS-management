// import dio client
import '../../../core/api/dio_client.dart';

// Class service untuk mengelola data user
class UserManagementService {
  // ==============================
  // GET ALL USERS
  // ==============================

  Future<List<dynamic>> getUsers({int page = 1, int limit = 10}) async {
    final response = await DioClient.dio.get(
      "/users",
      queryParameters: {"page": page, "limit": limit},
    );

    return response.data["data"];
  }

  // ==============================
  // CREATE USER
  // ==============================

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    await DioClient.dio.post(
      "/users",
      data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      },
    );
  }

  // ==============================
  // UPDATE USER
  // ==============================

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await DioClient.dio.put("/users/$userId", data: data);
  }

  // ==============================
  // RESET PASSWORD USER
  // SUPER ADMIN
  // ==============================

  Future<void> resetPassword({
    required String userId,
    required String newPassword,
  }) async {
    await DioClient.dio.put(
      "/users/$userId/reset-password",
      data: {"password": newPassword, "confirmPassword": newPassword},
    );
  }

  // ==============================
  // TRANSFER USER
  // ==============================

  Future<void> transferUser(String userId, String newOwnerId) async {
    await DioClient.dio.patch(
      "/users/$userId/transfer",

      data: {"newOwnerId": newOwnerId},
    );
  }

  // ==============================
  // NONAKTIFKAN USER
  // ==============================

  Future<void> deactivateUser(String userId) async {
    await DioClient.dio.patch("/users/$userId/deactivate");
  }

  // ==============================
  // AKTIFKAN USER
  // ==============================

  Future<void> activateUser(String userId) async {
    await DioClient.dio.put("/users/activate/$userId");
  }

  // ==============================
  // SUSPEND USER
  // ==============================

  Future<void> suspendUser(String userId, String reason) async {
    await DioClient.dio.patch(
      "/users/$userId/suspend",

      data: {"reason": reason},
    );
  }

  // ==============================
  // AKTIFKAN SUSPEND USER
  // ==============================

  Future<void> activateSuspendUser(String userId) async {
    await DioClient.dio.patch("/users/$userId/activate-suspend");
  }

  // ==============================
  // PERPANJANG MODUL USER
  // ==============================

  Future<void> extendModule(String userId, int days) async {
    await DioClient.dio.patch("/users/$userId/extend", data: {"days": days});
  }

  // ==============================
  // GET MY USERS
  // ==============================

  Future<List<dynamic>> getMyUsers({int page = 1, int limit = 10}) async {
    final response = await DioClient.dio.get(
      "/users/my-users",
      queryParameters: {"page": page, "limit": limit},
    );

    return response.data["data"];
  }
}
