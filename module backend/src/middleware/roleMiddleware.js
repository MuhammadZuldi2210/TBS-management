// Middleware untuk membatasi akses berdasarkan role
const authorize = (...allowedRoles) => {
  // Mengembalikan middleware function
  return (req, res, next) => {
    // Memastikan data user tersedia dari middleware protect
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized",
      });
    }

    // Mengambil role user dari token
    const userRole = req.user.role;

    // Mengecek apakah role user termasuk role yang diizinkan
    if (!allowedRoles.includes(userRole)) {
      return res.status(403).json({
        success: false,
        message: `Role ${userRole} tidak memiliki akses ke halaman ini`,
      });
    }

    // Melanjutkan ke middleware atau controller berikutnya
    next();
  };
};

// Export middleware
module.exports = authorize;
