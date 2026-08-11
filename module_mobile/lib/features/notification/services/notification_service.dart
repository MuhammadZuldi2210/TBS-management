// import dio client
import '../../../core/api/dio_client.dart';

class NotificationService {
  // ==========================
  // GET NOTIFICATIONS
  // ==========================

  Future<List<dynamic>> getNotifications() async {
    final response = await DioClient.dio.get("/notifications");

    return response.data["data"];
  }

  // ==========================
  // GET UNREAD COUNT
  // ==========================

  Future<int> getUnreadCount() async {
    final response = await DioClient.dio.get("/notifications/unread");

    return response.data["total"] ?? 0;
  }

  // ==========================
  // MARK AS READ
  // ==========================

  Future<void> markAsRead(String id) async {
    await DioClient.dio.put("/notifications/$id/read");
  }

  // ==========================
  // MARK ALL READ
  // ==========================

  Future<void> markAllAsRead() async {
    await DioClient.dio.put("/notifications/read-all");
  }

  // ==========================
  // DELETE
  // ==========================

  Future<void> deleteNotification(String id) async {
    await DioClient.dio.delete("/notifications/$id");
  }
}
