const express = require("express");
const router = express.Router();

// controller
const authController = require("../controllers/authController");

// Import middleware auth
const protect = require("../middleware/authMiddleware");

// Import middleware role
const authorize = require("../middleware/roleMiddleware");

// TEST ROUTE
router.get("/test", (req, res) => {
  res.json({ message: "auth route jalan" });
});

// Route REGISTER
router.post("/register", authController.registerUser);

// Route LOGIN
router.post("/login", authController.loginUser);

// Route PROFILE user yg sedang login
router.get("/profile", protect, authController.getProfile);

// Route update profile user yang sedang login
router.put("/profile", protect, authController.updateProfile);

// Route mengganti password user yang sedang login
router.put("/change-password", protect, authController.changePassword);

// Route mengambil daftar admin aktif
router.get("/admins", authController.getAdminList);

// Route hanya untuk super admin
router.get(
  "/super-admin",

  // Memastikan user sudah login
  protect,

  // Hanya super_admin yang boleh mengakses
  authorize("super_admin"),

  // Response
  (req, res) => {
    res.json({
      success: true,
      message: "Selamat datang Super Admin",
      user: req.user,
    });
  },
);

module.exports = router;
