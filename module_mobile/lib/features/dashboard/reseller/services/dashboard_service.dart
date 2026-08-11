// import dio
import 'package:dio/dio.dart';

// import dio client
import '../../../../core/api/dio_client.dart';

// Service Dashboard Admin & Reseller
class DashboardService {
  // ==============================
  // DASHBOARD ADMIN
  // ==============================

  // Ambil statistik dashboard admin
  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final Response response = await DioClient.dio.get("/dashboard/admin");

      return response.data["data"];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengambil dashboard admin",
      );
    }
  }

  // ==============================
  // DASHBOARD RESELLER
  // ==============================

  // Ambil statistik dashboard reseller
  Future<Map<String, dynamic>> getResellerStats() async {
    try {
      final Response response = await DioClient.dio.get("/dashboard/reseller");

      return response.data["data"];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengambil dashboard reseller",
      );
    }
  }
}
