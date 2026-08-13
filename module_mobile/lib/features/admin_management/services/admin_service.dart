import '../../../core/api/dio_client.dart';

// Class service untuk mengelola data admin
class AdminService {
  // mengambil seluruh daftar admin
  Future<List<dynamic>> getAdmins() async {
    // request daftar admin
    final response = await DioClient.dio.get("/admins");

    return response.data["data"];
  }

  // mengambil detail admin berdasarkan id
  Future<Map<String, dynamic>> getAdminDetail(String id) async {
    // request detail admin
    final response = await DioClient.dio.get("/admins/$id");

    return response.data;
  }

  // menambahkan admin baru
  Future<Map<String, dynamic>> createAdmin({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // request tambah admin
    final response = await DioClient.dio.post(
      "/admins",
      data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      },
    );

    return response.data;
  }

  // mengupdate data admin
  Future<Map<String, dynamic>> updateAdmin({
    required String id,
    required String name,
    required String email,
  }) async {
    // request update admin
    final response = await DioClient.dio.put(
      "/admins/$id",
      data: {"name": name, "email": email},
    );

    return response.data;
  }

  // RESET PASSWORD ADMIN
  Future<Map<String, dynamic>> resetPassword({
    required String id,
    required String newPassword,
  }) async {
    final response = await DioClient.dio.put(
      "/admins/$id/reset-password",
      data: {"newPassword": newPassword},
    );

    return response.data;
  }

  // menonaktifkan admin
  Future<Map<String, dynamic>> deactivateAdmin(String id) async {
    // request nonaktifkan admin
    final response = await DioClient.dio.patch("/admins/$id/deactivate");

    return response.data;
  }

  // mengaktifkan kembali admin
  Future<Map<String, dynamic>> activateAdmin(String id) async {
    // request aktifkan admin
    final response = await DioClient.dio.patch("/admins/$id/activate");

    return response.data;
  }

  // mensuspend admin
  Future<Map<String, dynamic>> suspendAdmin({
    required String id,
    String? reason,
  }) async {
    // request suspend admin
    final response = await DioClient.dio.patch(
      "/admins/$id/suspend",
      data: {"reason": reason ?? ""},
    );

    return response.data;
  }

  // mengaktifkan kembali admin yang disuspend
  Future<Map<String, dynamic>> activateSuspend(String id) async {
    final response = await DioClient.dio.patch("/admins/$id/activate-suspend");

    return response.data;
  }

  // mengambil daftar reseller milik admin
  Future<List<dynamic>> getAdminResellers(String id) async {
    // request daftar reseller
    final response = await DioClient.dio.get("/admins/$id/resellers");

    return response.data["data"];
  }

  // mengambil daftar owner untuk transfer user
  Future<List<dynamic>> getTransferOwners() async {
    // request daftar owner
    final response = await DioClient.dio.get("/admins/transfer-owners");

    return response.data["data"];
  }
}
