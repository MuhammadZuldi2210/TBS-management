// Mengimport jwt
const jwt = require("jsonwebtoken");

// Mengimport model User
const User = require("../models/User");

// middleware untuk mengecek apakah user sudah login
const protect = async (req, res, next) => {
  try {
    // Mengambil header authorization
    const authHeader = req.headers.authorization;

    // Jika token tidak ada
    if (!authHeader) {
      return res.status(401).json({
        success: false,
        message: "token tidak ditemukan",
      });
    }

    // Mengambil token setelah kata bearer
    const token = authHeader?.split(" ")[1];

    // Verifikasi token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Mengambil user dari database
    const user = await User.findById(decoded.id).select("-password");

    // ❗ CEK USER DULU
    if (!user) {
      return res.status(401).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // ❗ CEK ROLE
    if (!user.role) {
      return res.status(401).json({
        success: false,
        message: "role tidak valid",
      });
    }

    // Jika akun dinonaktifkan
    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        message: "Akun telah dinonaktifkan",
      });
    }

    // cek masa aktif modul
    if (user.moduleExpiredAt && new Date(user.moduleExpiredAt) < new Date()) {
      return res.status(403).json({
        success: false,
        message: "Modul Anda sudah expired, silakan perpanjang",
      });
    }

    // simpan user ke request
    req.user = user;

    next();
  } catch (error) {
    // Jika token sudah expired
    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        message: "Token expired",
      });
    }
    // Jika token tidak valid
    return res.status(401).json({
      success: false,
      message: "token tidak valid",
    });
  }
};

module.exports = protect;
