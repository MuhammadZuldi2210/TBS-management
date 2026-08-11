// ===============================================
// IMPORT EXPRESS
// ===============================================

const express = require("express");
const router = express.Router();

// ===============================================
// IMPORT CONTROLLER
// ===============================================

const {
  getSuperAdminStats,
  getAdminStats,
  getResellerStats,
  getAllAdmins,
  getAllUsers,
} = require("../controllers/dashboardController");

// ===============================================
// IMPORT MIDDLEWARE
// ===============================================

const protect = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

// ===============================================
// DASHBOARD
// ===============================================

// Dashboard Super Admin
router.get(
  "/super-admin",
  protect,
  authorize("super_admin"),
  getSuperAdminStats,
);

// Dashboard Admin
router.get(
  "/admin",
  protect,
  authorize("super_admin", "admin_user"),
  getAdminStats,
);

// Dashboard Reseller
router.get(
  "/reseller",
  protect,
  authorize("super_admin", "reseller"),
  getResellerStats,
);

// ===============================================
// LIST DATA
// ===============================================

// Seluruh Admin
router.get("/admins", protect, authorize("super_admin"), getAllAdmins);

// Seluruh User
router.get("/users", protect, authorize("super_admin"), getAllUsers);

// ===============================================
// EXPORT ROUTER
// ===============================================

module.exports = router;
