// import flutter material
import 'package:flutter/material.dart';

// import service
import '../services/notification_service.dart';

// Provider Notification
class NotificationProvider extends ChangeNotifier {
  // instance service
  final NotificationService _service = NotificationService();

  // ==========================
  // DATA
  // ==========================

  // list notification
  List notificationList = [];

  // jumlah unread
  int unreadCount = 0;

  // loading
  bool isLoading = false;

  // error
  String? errorMessage;

  // ==========================
  // GET NOTIFICATIONS
  // ==========================

  Future getNotifications() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      // Ambil notification + unread count
      final notifications = await _service.getNotifications();
      final unread = await _service.getUnreadCount();

      notificationList = notifications;
      unreadCount = unread;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================
  // MARK AS READ
  // ==========================

  Future markAsRead(String id) async {
    try {
      errorMessage = null;

      await _service.markAsRead(id);

      // Update lokal supaya badge langsung berubah
      final index = notificationList.indexWhere(
        (notification) => notification["_id"] == id,
      );

      if (index != -1) {
        final notification = notificationList[index];

        // Kalau sebelumnya unread
        if (notification["isRead"] != true) {
          notification["isRead"] = true;

          if (unreadCount > 0) {
            unreadCount--;
          }
        }
      }

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // MARK ALL READ
  // ==========================

  Future markAllAsRead() async {
    try {
      errorMessage = null;

      await _service.markAllAsRead();

      // Semua notification menjadi read
      for (final notification in notificationList) {
        notification["isRead"] = true;
      }

      // Badge langsung menjadi 0
      unreadCount = 0;

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // DELETE
  // ==========================

  Future deleteNotification(String id) async {
    try {
      errorMessage = null;

      // Cari notification sebelum dihapus
      final index = notificationList.indexWhere(
        (notification) => notification["_id"] == id,
      );

      if (index == -1) {
        return;
      }

      final notification = notificationList[index];

      // Simpan status unread
      final wasUnread = notification["isRead"] != true;

      // Hapus dari backend
      await _service.deleteNotification(id);

      // Hapus langsung dari state lokal
      notificationList.removeAt(index);

      // Kalau notification yang dihapus masih unread,
      // kurangi badge
      if (wasUnread && unreadCount > 0) {
        unreadCount--;
      }

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // ==========================
  // RESET
  // ==========================

  void clearNotifications() {
    notificationList = [];
    unreadCount = 0;
    errorMessage = null;

    notifyListeners();
  }
}
