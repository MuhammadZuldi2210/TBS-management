// ===============================================
// IMPORT EXPRESS
// ===============================================

const express = require("express");
const router = express.Router();

// ===============================================
// IMPORT MIDDLEWARE
// ===============================================

const protect = require("../middleware/authMiddleware");

// ===============================================
// IMPORT CONTROLLER
// ===============================================

const {
  getMyNotifications,
  getUnreadCount,
  markAsRead,
  markAllAsRead,
  deleteNotification,
} = require("../controllers/notificationController");

// ===============================================
// NOTIFICATION ROUTES
// ===============================================

// Ambil semua notifikasi user login
router.get("/", protect, getMyNotifications);

// Hitung notifikasi yang belum dibaca
router.get("/unread", protect, getUnreadCount);

// Tandai satu notifikasi sudah dibaca
router.put("/:id/read", protect, markAsRead);

// Tandai semua notifikasi sudah dibaca
router.put("/read-all", protect, markAllAsRead);

// Hapus satu notifikasi
router.delete("/:id", protect, deleteNotification);

module.exports = router;
