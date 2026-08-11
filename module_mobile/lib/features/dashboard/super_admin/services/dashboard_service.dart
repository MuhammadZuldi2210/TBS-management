// import dio client
import '../../../../core/api/dio_client.dart';

// service dashboard
class DashboardService {
  // mengambil statistik super admin
  Future<Map<String, dynamic>> getStats() async {
    // request ke backend
    final response = await DioClient.dio.get("/dashboard/super-admin");

    // ambil data statistik
    return response.data["data"];
  }
}
