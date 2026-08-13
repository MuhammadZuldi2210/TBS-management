// import dio client
import '../../../core/api/dio_client.dart';

class TransactionService {
  // ==================================
  // GET ALL TRANSACTIONS
  // ==================================

  // ==================================
  // GET ALL TRANSACTIONS
  // ==================================

  Future<List<dynamic>> getTransactions({
    String? type,
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await DioClient.dio.get(
      "/transactions",
      queryParameters: {
        // pagination
        "page": page,
        "limit": limit,

        // filter jenis transaksi
        if (type != null) "type": type,

        // filter status
        if (status != null) "status": status,
      },
    );

    return response.data["data"];
  }

  // ==================================
  // APPROVE TRANSACTION
  // ==================================

  Future<void> approveTransaction(String id) async {
    await DioClient.dio.put("/coins/approve/$id");
  }
}
