// Import express
const express = require("express");

// Membuat router express
const router = express.Router();

// Import controller admin
const {
  createAdmin,
  getListAdmin,
  getDetailAdmin,
  getAdminResellers,
  updateAdmin,
  activateAdmin,
  deactivateAdmin,
  getTransferOwners,
  suspendAdmin,
} = require("../controllers/adminController");

// Import middleware authentication
const authMiddleware = require("../middleware/authMiddleware");

// Import middleware authorize
const authorize = require("../middleware/roleMiddleware");

// Endpoint untuk membuat admin baru
router.post(
  // Endpoint POST /api/admins
  "/",

  // Memastikan user sudah login
  authMiddleware,

  // Hanya super_admin yang boleh membuat admin
  authorize("super_admin"),

  // Menjalankan controller create admin
  createAdmin,
);

// Endpoint untuk mengambil seluruh daftar admin
router.get(
  // Endpoint get/api/admins
  "/",

  // Memastikan user sudah login
  authMiddleware,

  // Hanya super admin yg boleh melihat daftar admin
  authorize("super_admin"),

  // Menjalankan controller
  getListAdmin,
);

// Endpoint transfer user
router.get(
  "/transfer-owners",
  authMiddleware,
  authorize("super_admin"),
  getTransferOwners,
);

// Endpoint suspend admin
router.patch(
  "/:id/suspend",

  authMiddleware,

  authorize("super_admin"),

  suspendAdmin,
);

// Endpoint aktifkan kembali admin suspend
router.patch(
  "/:id/activate-suspend",

  authMiddleware,

  authorize("super_admin"),

  activateAdmin,
);

// Endpoint untuk mengambil detail admin berdasarkan ID
router.get(
  // Endpoint GET/api/admins/:id
  "/:id",

  // Memastikan user sudah login
  authMiddleware,

  // Hanya super admin yg boleh melihat detail admin
  authorize("super_admin"),

  // Menjalakan controller get detail admin
  getDetailAdmin,
);

// Endpoint untuk liat detail reseller milik admin
router.get(
  "/:id/resellers",

  // Memastikan user sudah login
  authMiddleware,

  // Hanya super admin yang boleh melihat reseller
  authorize("super_admin"),

  // Menjalankan controller
  getAdminResellers,
);

// Endpoint untuk mengupdate data admin berdasarkan ID
router.put(
  // Endpoint PUT /api/admins/:id
  "/:id",

  // Memastikan user sudah login
  authMiddleware,

  // Hanya super admin yang boleh mengupdate admin
  authorize("super_admin"),

  // Menjalankan controller update admin
  updateAdmin,
);

// Endpoint untuk menonaktifkan admin
router.patch(
  // Endpoint PATCH /api/admins/:id/deactivate
  "/:id/deactivate",

  // Memastikan user sudah login
  authMiddleware,

  // Hanya super admin yang boleh menonaktifkan admin
  authorize("super_admin"),

  // Menjalankan controller deactivate admin
  deactivateAdmin,
);

// Endpoint untuk mengaktifkan kembali admin
router.patch(
  // Endpoint PATCH /api/admins/:id/activate
  "/:id/activate",

  // Memastikan user sudah login
  authMiddleware,

  // Hanya super admin yang boleh mengaktifkan admin
  authorize("super_admin"),

  // Menjalankan controller activate admin
  activateAdmin,
);

// Export router
module.exports = router;
