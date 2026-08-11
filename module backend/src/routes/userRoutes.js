const express = require("express");
const router = express.Router();

// Import controller user
const userController = require("../controllers/userController");

// Import middleware login
const protect = require("../middleware/authMiddleware");

// Import middleware role
const authorize = require("../middleware/roleMiddleware");

// Mengambil daftar user
// Bisa diakses super admin dan admin user
router.get(
  "/",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.getUsers,
);

// Mengambil semua user milik admin
router.get(
  "/admin/:id/users",
  protect,
  authorize("super_admin"),
  userController.getUsersByAdmin,
);

// Mengambil semua user milik reseller
router.get(
  "/reseller/:id/users",
  protect,
  authorize("super_admin", "admin_user"),
  userController.getUsersByReseller,
);

// Mengambil user milik sendiri (Super Admin)
router.get(
  "/my-users",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.getMyUsers,
);

// Membuat user baru
router.post(
  "/",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.createUser,
);

// UPDATE USER
router.put(
  "/:id",
  protect,
  authorize("super_admin"),
  userController.updateUser,
);

// NONAKTIF USER
router.patch(
  "/:id/deactivate",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.deactivateUser,
);

// TRANSFER USER
router.patch(
  "/:id/transfer",
  protect,
  authorize("super_admin"),
  userController.transferUser,
);

// SUSPEND USER
router.patch(
  "/:id/suspend",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.suspendUser,
);

// AKTIFKAN SUSPEND
router.patch(
  "/:id/activate-suspend",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.activateSuspendUser,
);

// EXTEND MODULE USER
router.patch(
  "/:id/extend",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.extendModule,
);

// AKTIFKAN USER KEMBALI
router.put(
  "/activate/:id",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  userController.activateUser,
);

// Export route
module.exports = router;
