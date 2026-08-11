// Mengimport model User
const User = require("../models/User");

// Controller dashboard user
const getUserDashboard = async (req, res) => {
  try {
    // Mengambil data user yang sedang login
    const user = await User.findById(req.user._id).select("-password");

    // Jika user tidak ditemukan
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Variabel sisa hari aktif
    let daysRemaining = 0;

    // Menghitung sisa hari jika user memiliki tanggal expired
    if (user.moduleExpiredAt) {
      const now = new Date();

      const diff = user.moduleExpiredAt.getTime() - now.getTime();

      daysRemaining = Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));
    }

    // Mengirim data dashboard
    res.status(200).json({
      success: true,
      data: {
        id: user._id,

        name: user.name,

        email: user.email,

        phone: user.phone,

        role: user.role,

        paymentStatus: user.paymentStatus,

        isActive: user.isActive,

        moduleExpiredAt: user.moduleExpiredAt,

        daysRemaining,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Gagal mengambil dashboard user",
      error: error.message,
    });
  }
};

// Export controller
module.exports = {
  getUserDashboard,
};
