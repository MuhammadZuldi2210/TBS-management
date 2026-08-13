// import dio package
import 'package:dio/dio.dart';

// import secure storage
import '../storage/secure_storage.dart';

// Class utama untuk HTTP Client
class DioClient {
  // Instance Dio global
  static final Dio dio = Dio(
    BaseOptions(
      // Base URL backend
      baseUrl: "https://tbs-management-production.up.railway.app/api",

      // Timeout koneksi
      connectTimeout: const Duration(seconds: 10),

      // Timeout menerima response
      receiveTimeout: const Duration(seconds: 10),

      // Response berupa JSON
      responseType: ResponseType.json,
    ),
  );

  // Inisialisasi interceptor
  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        // Sebelum request dikirim ke backend
        onRequest: (options, handler) async {
          // Ambil token dari Secure Storage
          final token = await SecureStorage.getToken();

          // Jika token ada, tambahkan ke Authorization Header
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          // Lanjutkan request
          return handler.next(options);
        },

        // Jika request berhasil
        onResponse: (response, handler) {
          // Lanjutkan response
          return handler.next(response);
        },

        // Jika terjadi error
        onError: (DioException e, handler) {
          // Jika token tidak valid atau expired
          if (e.response?.statusCode == 401) {
            // Nanti kita tambahkan auto logout di sini
          }

          // Lanjutkan error
          return handler.next(e);
        },
      ),
    );
  }
}
