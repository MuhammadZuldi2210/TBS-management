const express = require("express");
const router = express.Router();

// Import controller coin
const coinController = require("../controllers/coinController");

// Import middleware login
const protect = require("../middleware/authMiddleware");

// Import middleware role
const authorize = require("../middleware/roleMiddleware");

// Topup coin ke admin user
// Hanya super admin yang boleh melakukan topup
router.post(
  "/topup",
  protect,
  authorize("super_admin"),
  coinController.topupCoin,
);

// Admin user membuat request coin
router.post(
  "/request",
  protect,
  authorize("admin_user", "reseller"),
  coinController.requestCoin,
);

// Mengambil saldo coin milik akun yang sedang login
router.get(
  "/balance",
  protect,
  authorize("super_admin", "admin_user", "reseller"),
  coinController.getBalance,
);

// GET ALL HISTORY COIN
router.get(
  "/history",
  protect,
  authorize("super_admin"),
  coinController.getCoinHistory,
);

// Melihat seluruh request coin pending
router.get(
  "/pending",
  protect,
  authorize("super_admin"),
  coinController.getPendingRequests,
);

// Approve request coin
router.put(
  "/approve/:id",
  protect,
  authorize("super_admin", "admin_user"),
  coinController.approveCoinRequest,
);

// Export route
module.exports = router;
