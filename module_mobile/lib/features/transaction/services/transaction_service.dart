// import dio client
import '../../../core/api/dio_client.dart';

class TransactionService {
  // ==================================
  // GET ALL TRANSACTIONS
  // ==================================

  Future<List<dynamic>> getTransactions({String? type, String? status}) async {
    final response = await DioClient.dio.get(
      "/transactions",

      queryParameters: {
        // filter jenis transaksi
        if (type != null) "type": type,

        // filter status
        if (status != null) "status": status,
      },
    );

    // tampilkan maksimal 20 transaksi agar ringan
    return response.data["data"].take(20).toList();
  }

  // ==================================
  // APPROVE TRANSACTION
  // ==================================

  Future<void> approveTransaction(String id) async {
    await DioClient.dio.put("/coins/approve/$id");
  }
}
