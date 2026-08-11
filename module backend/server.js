const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const helmet = require("helmet");
const compression = require("compression");
const morgan = require("morgan");

const createSuperAdmin = require("./src/seed/superAdmin");
const connectDatabase = require("./src/config/database");
const startExpireJob = require("./src/jobs/expireJob");

const authRoutes = require("./src/routes/authRoutes");
const adminRoutes = require("./src/routes/adminRoutes");
const userRoutes = require("./src/routes/userRoutes");
const coinRoutes = require("./src/routes/coinRoutes");
const transactionRoutes = require("./src/routes/transactionRoutes");
const dashboardRoutes = require("./src/routes/dashboardRoutes");
const notificationRoutes = require("./src/routes/notificationRoutes");
const userDashboardRoutes = require("./src/routes/userDashboardRoutes");
const resellerRoutes = require("./src/routes/resellerRoutes");
const suspendRoutes = require("./src/routes/suspendRoutes");

dotenv.config();

const app = express();

// MIDDLEWARE
app.use(
  cors({
    origin: "*", // izinkan semua akses (development)
    methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  }),
);
app.use(helmet());
app.use(compression());
app.use(morgan("dev"));
app.use(express.json());

// ROUTES
app.use("/api/auth", authRoutes);
app.use("/api/admins", adminRoutes);
app.use("/api/users", userRoutes);
app.use("/api/coins", coinRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/notifications", notificationRoutes);
app.use("/api/user/dashboard", userDashboardRoutes);
app.use("/api/resellers", resellerRoutes);
app.use("/api/suspend", suspendRoutes);

// TEST ROUTE
app.get("/", (req, res) => {
  res.status(200).json({
    success: true,
    message: "module backend API running",
  });
});

const PORT = process.env.PORT || 5000;

// 🔥 SINGLE INIT
const startServer = async () => {
  try {
    await connectDatabase();
    await createSuperAdmin();

    startExpireJob();

    app.listen(PORT, "0.0.0.0", () => {
      console.log(`server berjalan di port ${PORT}`);
    });
  } catch (error) {
    console.log("Server error:", error.message);
  }
};

startServer();
