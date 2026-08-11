const express = require("express");

// Membuat router express
const router = express.Router();

// Import controller transaction
const {
  getTransactions,
  getTransactionDetail,
  approveTransaction,
} = require("../controllers/transactionController");

// Import middleware
const authMiddleware = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

// =========================
// GET ALL TRANSACTIONS
// =========================
router.get(
  "/",
  authMiddleware,
  authorize("super_admin", "admin_user", "reseller"),
  getTransactions,
);

// =========================
// GET DETAIL TRANSACTION
// =========================
router.get(
  "/:id",
  authMiddleware,
  authorize("super_admin", "admin_user", "reseller"),
  getTransactionDetail,
);

// =========================
// SEMENTARA DINONAKTIFKAN
// =========================

// router.post("/module-extension", createModuleExtensionRequest);

// Export router
module.exports = router;
