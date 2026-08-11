const express = require("express");

const router = express.Router();

// Import controller
const { getUserDashboard } = require("../controllers/userDashboardController");

// Import middleware
const protect = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

// Dashboard user
router.get("/", protect, authorize("user"), getUserDashboard);

module.exports = router;
