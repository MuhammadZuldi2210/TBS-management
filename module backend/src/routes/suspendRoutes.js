const express = require("express");
const router = express.Router();

// Middleware
const protect = require("../middleware/authMiddleware");

// Controller
const {
  suspendUser,
  activateUser,
} = require("../controllers/suspendController");

// Suspend akun
router.patch("/:id/suspend", protect, suspendUser);

// Aktifkan kembali akun
router.patch("/:id/activate", protect, activateUser);

module.exports = router;
