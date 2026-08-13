// Import model User
const User = require("../models/User");

// Import bcrypt untuk hash password
const bcrypt = require("bcryptjs");

// Import notification models
const Notification = require("../models/Notification");

// ==============================
// CREATE RESELLER
// ==============================

const createReseller = async (req, res) => {
  try {
    // Mengambil data request
    const { name, email, password, phone } = req.body;

    // Cek role pembuat
    if (req.user.role !== "super_admin" && req.user.role !== "admin_user") {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses membuat reseller",
      });
    }

    // Validasi input
    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: "Nama, email dan password wajib diisi",
      });
    }

    // Cek email
    const existingUser = await User.findOne({
      email,
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: "Email sudah digunakan",
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Membuat reseller baru
    const reseller = await User.create({
      name,

      email,

      password: hashedPassword,

      // Role reseller
      role: "reseller",

      phone,

      // Yang membuat reseller
      createdBy: req.user._id,

      // Pemilik reseller
      ownerId: req.user._id,

      // Coin awal
      coinBalance: 0,

      // Status aktif
      isActive: true,
    });

    // Jika Admin membuat reseller, kirim notifikasi ke Super Admin
    if (req.user.role === "admin_user") {
      const superAdmins = await User.find({
        role: "super_admin",
      });

      for (const admin of superAdmins) {
        await Notification.create({
          userId: admin._id,
          createdBy: req.user._id,
          title: "Reseller Baru",
          message: `${req.user.name} menambahkan reseller ${reseller.name}`,
          type: "account",
        });
      }
    }

    return res.status(201).json({
      success: true,

      message: "Reseller berhasil dibuat",

      data: {
        _id: reseller._id,
        name: reseller.name,
        email: reseller.email,
        phone: reseller.phone,
        role: reseller.role,
      },
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,

      message: "Server Error",
    });
  }
};

// ==============================
// GET LIST RESELLER
// ==============================

const getListReseller = async (req, res) => {
  try {
    // Filter reseller
    let filter = {
      role: "reseller",
    };

    // Jika login sebagai Admin
    // hanya melihat reseller miliknya
    if (req.user.role === "admin_user") {
      filter.ownerId = req.user._id;
    }

    // Jika bukan super admin atau admin
    if (req.user.role !== "super_admin" && req.user.role !== "admin_user") {
      return res.status(403).json({
        success: false,

        message: "Akses ditolak",
      });
    }

    const resellers = await User.find(filter)

      .populate("ownerId", "name email role")

      .select("-password")

      .sort({
        createdAt: -1,
      });

    const resellerWithStats = await Promise.all(
      resellers.map(async (reseller) => {
        const totalUser = await User.countDocuments({
          role: "user",
          ownerId: reseller._id,
        });

        return {
          ...reseller.toObject(),

          totalUser,
        };
      }),
    );

    return res.status(200).json({
      success: true,

      data: resellerWithStats,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,

      message: "Server Error",
    });
  }
};

// ==============================
// GET DETAIL RESELLER
// ==============================

const getDetailReseller = async (req, res) => {
  try {
    // Mengambil id reseller dari parameter
    const { id } = req.params;

    // Mencari reseller
    const reseller = await User.findOne({
      _id: id,
      role: "reseller",
    })
      .populate("ownerId", "name email role")
      .select("-password");

    // Jika reseller tidak ditemukan
    if (!reseller) {
      return res.status(404).json({
        success: false,
        message: "Reseller tidak ditemukan",
      });
    }

    // Cek akses
    // Admin hanya boleh melihat reseller miliknya
    if (
      req.user.role === "admin_user" &&
      reseller.ownerId.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Reseller bukan milik anda",
      });
    }

    // Menghitung jumlah user milik reseller
    const totalUser = await User.countDocuments({
      role: "user",
      ownerId: reseller._id,
    });

    // Menghitung user aktif
    const activeUser = await User.countDocuments({
      role: "user",

      ownerId: reseller._id,

      paymentStatus: "active",
    });

    // Menghitung user expired
    const expiredUser = await User.countDocuments({
      role: "user",

      ownerId: reseller._id,

      paymentStatus: "expired",
    });

    // Response
    return res.status(200).json({
      success: true,

      data: {
        // Data reseller
        reseller: {
          _id: reseller._id,

          name: reseller.name,

          email: reseller.email,

          phone: reseller.phone,

          role: reseller.role,

          coinBalance: reseller.coinBalance,

          isActive: reseller.isActive,

          createdAt: reseller.createdAt,
        },

        // Statistik reseller
        statistics: {
          totalUser,

          activeUser,

          expiredUser,
        },
      },
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,

      message: "Server Error",
    });
  }
};

// ==============================
// DEACTIVATE RESELLER
// ==============================

const deactivateReseller = async (req, res) => {
  try {
    // Hanya Super Admin dan Admin yang boleh menonaktifkan reseller
    if (req.user.role !== "super_admin" && req.user.role !== "admin_user") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    // Ambil id reseller
    const { id } = req.params;

    // Cari reseller
    const reseller = await User.findOne({
      _id: id,
      role: "reseller",
    });

    if (!reseller) {
      return res.status(404).json({
        success: false,
        message: "Reseller tidak ditemukan",
      });
    }

    // Admin hanya boleh menonaktifkan reseller miliknya
    if (
      req.user.role === "admin_user" &&
      reseller.ownerId.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Reseller bukan milik anda",
      });
    }

    // Cek status
    if (!reseller.isActive) {
      return res.status(400).json({
        success: false,
        message: "Reseller sudah nonaktif",
      });
    }

    // Nonaktifkan
    reseller.isActive = false;

    await reseller.save();

    return res.status(200).json({
      success: true,
      message: "Reseller berhasil dinonaktifkan",
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ==============================
// ACTIVATE RESELLER
// ==============================

const activateReseller = async (req, res) => {
  try {
    // Hanya Super Admin dan Admin
    if (req.user.role !== "super_admin" && req.user.role !== "admin_user") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    const { id } = req.params;

    const reseller = await User.findOne({
      _id: id,
      role: "reseller",
    });

    if (!reseller) {
      return res.status(404).json({
        success: false,
        message: "Reseller tidak ditemukan",
      });
    }

    // Admin hanya boleh mengaktifkan reseller miliknya
    if (
      req.user.role === "admin_user" &&
      reseller.ownerId.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Reseller bukan milik anda",
      });
    }

    if (reseller.isActive) {
      return res.status(400).json({
        success: false,
        message: "Reseller sudah aktif",
      });
    }

    reseller.isActive = true;

    reseller.accountStatus = "active";

    reseller.suspendedBy = null;

    reseller.suspendedAt = null;

    reseller.suspendReason = "";

    await reseller.save();

    return res.status(200).json({
      success: true,
      message: "Reseller berhasil diaktifkan",
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ==============================
// GET MY RESELLER
// ==============================

const getMyReseller = async (req, res) => {
  try {
    // Hanya Super Admin dan Admin User
    if (req.user.role !== "super_admin" && req.user.role !== "admin_user") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    // Ambil reseller milik user yang login
    const resellers = await User.find({
      role: "reseller",
      ownerId: req.user._id,
    })
      .select("-password")
      .sort({
        createdAt: -1,
      });

    const resellerWithStats = await Promise.all(
      resellers.map(async (reseller) => {
        const totalUser = await User.countDocuments({
          role: "user",
          ownerId: reseller._id,
        });

        return {
          ...reseller.toObject(),
          totalUser,
        };
      }),
    );

    return res.status(200).json({
      success: true,
      data: resellerWithStats,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ==============================
// GET USER RESELLER
// ==============================

const getResellerUsers = async (req, res) => {
  try {
    const { id } = req.params;

    // Cek reseller
    const reseller = await User.findOne({
      _id: id,
      role: "reseller",
    });

    if (!reseller) {
      return res.status(404).json({
        success: false,
        message: "Reseller tidak ditemukan",
      });
    }

    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Filter user milik reseller
    const filter = {
      role: "user",
      ownerId: id,
    };

    // Ambil user sesuai halaman
    const users = await User.find(filter)
      .select("-password")
      .sort({
        createdAt: -1,
      })
      .skip(skip)
      .limit(limit);

    // Hitung total user
    const total = await User.countDocuments(filter);

    return res.status(200).json({
      success: true,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      data: users,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ==============================
// UPDATE RESELLER
// ==============================

const updateReseller = async (req, res) => {
  try {
    const { id } = req.params;

    const reseller = await User.findOne({
      _id: id,
      role: "reseller",
    });

    if (!reseller) {
      return res.status(404).json({
        success: false,
        message: "Reseller tidak ditemukan",
      });
    }

    reseller.name = req.body.name ?? reseller.name;

    reseller.phone = req.body.phone ?? reseller.phone;

    await reseller.save();

    return res.status(200).json({
      success: true,
      message: "Reseller berhasil diperbarui",
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ==============================
// SUSPEND RESELLER
// ==============================
const suspendReseller = async (req, res) => {
  try {
    const { id } = req.params;

    const { reason } = req.body;

    const reseller = await User.findOne({
      _id: id,
      role: "reseller",
    });

    if (!reseller) {
      return res.status(404).json({
        success: false,
        message: "Reseller tidak ditemukan",
      });
    }

    // Admin hanya boleh suspend reseller miliknya
    if (
      req.user.role === "admin_user" &&
      reseller.ownerId.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Reseller bukan milik anda",
      });
    }

    // Suspend reseller
    reseller.accountStatus = "suspended";

    reseller.isActive = false;

    reseller.suspendReason = reason || "";

    reseller.suspendedBy = req.user._id;

    reseller.suspendedAt = new Date();

    await reseller.save();

    return res.status(200).json({
      success: true,

      message: "Reseller berhasil disuspend",

      data: reseller,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,

      message: "Server Error",
    });
  }
};

// Export controller

module.exports = {
  createReseller,
  getListReseller,
  getDetailReseller,
  deactivateReseller,
  activateReseller,
  getMyReseller,
  getResellerUsers,
  updateReseller,
  suspendReseller,
};
