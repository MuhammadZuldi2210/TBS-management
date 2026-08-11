// import dio client
import '../../../core/api/dio_client.dart';

class CoinService {
  // ===============================
  // REQUEST COIN
  // ADMIN / RESELLER
  // ===============================
  Future requestCoin({
    required int amount,
    required String requestTo,
    String? notes,
  }) async {
    final response = await DioClient.dio.post(
      "/coins/request",
      data: {"amount": amount, "requestTo": requestTo, "notes": notes ?? ""},
    );

    return response.data;
  }

  // ===============================
  // GET MY RESELLER
  // ===============================
  Future getMyReseller() async {
    final response = await DioClient.dio.get("/resellers/my");

    return response.data["data"];
  }
}
