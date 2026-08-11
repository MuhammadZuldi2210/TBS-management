// Import express
const express = require("express");

// Membuat router
const router = express.Router();

// Import controller
const {
  createReseller,
  getListReseller,
  getDetailReseller,
  deactivateReseller,
  activateReseller,
  getMyReseller,
  getResellerUsers,
  updateReseller,
  suspendReseller,
} = require("../controllers/resellerController");

// Import middleware
const authMiddleware = require("../middleware/authMiddleware");

// Import authorize
const authorize = require("../middleware/roleMiddleware");

// Membuat reseller
router.post(
  "/",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  createReseller,
);

// Melihat daftar reseller
router.get(
  "/",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  getListReseller,
);

// Melihat reseller saya
router.get(
  "/my",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  getMyReseller,
);

// Detail reseller
router.get(
  "/:id",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  getDetailReseller,
);

// Nonaktifkan reseller
router.patch(
  "/:id/deactivate",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  deactivateReseller,
);

// Aktifkan reseller
router.patch(
  "/:id/activate",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  activateReseller,
);

// Get user reseller
router.get(
  "/:id/users",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  getResellerUsers,
);

// Edit reseller
router.put(
  "/:id",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  updateReseller,
);

// Suspend reseller
router.patch(
  "/:id/suspend",

  authMiddleware,

  authorize("super_admin", "admin_user"),

  suspendReseller,
);

// Export router
module.exports = router;
