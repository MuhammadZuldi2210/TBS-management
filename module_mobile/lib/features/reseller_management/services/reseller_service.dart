// import dio client
import '../../../core/api/dio_client.dart';

// Service untuk mengelola reseller
class ResellerService {
  // ==============================
  // CREATE RESELLER
  // ==============================

  Future<void> createReseller({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    await DioClient.dio.post(
      "/resellers",
      data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      },
    );
  }

  // ==============================
  // GET MY RESELLER
  // ==============================

  Future<List<dynamic>> getMyResellers() async {
    final response = await DioClient.dio.get("/resellers/my");

    return response.data["data"];
  }

  // ==============================
  // GET USER RESELLER
  // ==============================

  Future<List<dynamic>> getResellerUsers(
    String resellerId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await DioClient.dio.get(
      "/resellers/$resellerId/users",
      queryParameters: {"page": page, "limit": limit},
    );

    return response.data["data"];
  }

  // ==============================
  // UPDATE RESELLER
  // ==============================

  Future<void> updateReseller({
    required String resellerId,
    required String name,
    String? phone,
  }) async {
    await DioClient.dio.put(
      "/resellers/$resellerId",
      data: {"name": name, "phone": phone},
    );
  }

  // ==============================
  // SUSPEND RESELLER
  // ==============================

  Future<void> suspendReseller({
    required String resellerId,
    required String reason,
  }) async {
    await DioClient.dio.patch(
      "/resellers/$resellerId/suspend",
      data: {"reason": reason},
    );
  }

  // ==============================
  // DEACTIVATE RESELLER
  // ==============================

  Future<void> deactivateReseller(String resellerId) async {
    await DioClient.dio.patch("/resellers/$resellerId/deactivate");
  }

  // ==============================
  // ACTIVATE RESELLER
  // ==============================

  Future<void> activateReseller(String resellerId) async {
    await DioClient.dio.patch("/resellers/$resellerId/activate");
  }

  // ==============================
  // GET ALL RESELLERS
  // SUPER ADMIN
  // ==============================

  Future<List<dynamic>> getAllResellers() async {
    final response = await DioClient.dio.get("/resellers");

    return response.data["data"];
  }
}
