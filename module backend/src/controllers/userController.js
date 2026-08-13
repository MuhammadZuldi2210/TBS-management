// Mengimpor model User
const User = require("../models/User");

// Import bcrypt untuk hash password
const bcrypt = require("bcryptjs");

// Import model Transaction
const Transaction = require("../models/transactionModel");

// Import create notifikasi
const createNotification = require("../utils/createNotification");

/* =========================
   GET ALL USERS
========================= */
const getUsers = async (req, res) => {
  try {
    // Ambil query
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || "";

    // Pagination
    const skip = (page - 1) * limit;

    let filter = {};

    // =========================
    // SUPER ADMIN
    // lihat semua user
    // =========================
    if (req.user.role === "super_admin") {
      filter = {
        role: "user",
      };
    }

    // =========================
    // ADMIN USER
    // hanya user yang dibuat admin ini
    // =========================
    else if (req.user.role === "admin_user") {
      filter = {
        role: "user",
        ownerId: req.user._id,
      };
    }

    // =========================
    // RESELLER
    // hanya user miliknya
    // =========================
    else if (req.user.role === "reseller") {
      filter = {
        role: "user",

        ownerId: req.user._id,
      };
    } else {
      return res.status(403).json({
        success: false,
        message: "Role tidak memiliki akses",
      });
    }

    // Search
    if (search) {
      filter.$or = [
        {
          name: {
            $regex: search,
            $options: "i",
          },
        },

        {
          email: {
            $regex: search,
            $options: "i",
          },
        },
      ];
    }

    // Ambil data user
    const users = await User.find(filter)

      // tampilkan pemilik user
      .populate("ownerId", "name email phone role")

      // tampilkan pembuat user
      .populate("createdBy", "name email role")

      .select("-password")

      .skip(skip)

      .limit(limit)

      .sort({
        createdAt: -1,
      });

    // Total
    const total = await User.countDocuments(filter);

    return res.status(200).json({
      success: true,

      total,

      page,

      totalPages: Math.ceil(total / limit),

      data: users,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,

      message: "Server error",
    });
  }
};

/* =========================
   GET USER BY ADMIN
========================= */
const getUsersByAdmin = async (req, res) => {
  try {
    const { id } = req.params;

    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Filter user milik admin
    const filter = {
      role: "user",
      ownerId: id,
    };

    // Ambil user sesuai halaman
    const users = await User.find(filter)
      .populate("ownerId", "name email role")
      .populate("createdBy", "name email role")
      .select("-password")
      .sort({ createdAt: -1 })
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
    console.log("GET USERS BY ADMIN ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// ==========================================
// MENGAMBIL USER MILIK RESELLER
// ==========================================
const getUsersByReseller = async (req, res) => {
  try {
    const { id } = req.params;

    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Filter user milik reseller
    const filter = {
      ownerId: id,
      role: "user",
    };

    // Ambil user sesuai halaman
    const users = await User.find(filter)
      .select("-password")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    // Hitung total user
    const total = await User.countDocuments(filter);

    res.status(200).json({
      success: true,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      data: users,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/* =========================
   GET MY USERS
========================= */
const getMyUsers = async (req, res) => {
  try {
    console.log("LOGIN USER:", req.user._id);
    console.log("ROLE:", req.user.role);

    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Filter user milik user yang sedang login
    const filter = {
      role: "user",
      ownerId: req.user._id,
    };

    // Ambil user sesuai halaman
    const users = await User.find(filter)
      .populate("ownerId", "name email phone role")
      .populate("createdBy", "name email role")
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
      message: "Server error",
    });
  }
};

/* =========================
   CREATE USER
========================= */
const createUser = async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;

    // Validasi input
    if (!name || !email || !password || !phone) {
      return res.status(400).json({
        success: false,
        message: "Semua field wajib diisi",
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

    // Buat user baru
    const user = await User.create({
      name,
      email,
      password: hashedPassword,

      // User biasa
      role: "user",

      phone,

      // Pemilik mengikuti pembuat
      ownerId: req.user._id,

      // Pencatat pembuat
      createdBy: req.user._id,

      coinBalance: 0,

      paymentStatus: "pending",

      moduleExpiredAt: null,

      isActive: true,
    });

    // ===============================
    // NOTIFICATION USER BARU
    // ===============================

    // Admin membuat user
    if (req.user.role === "admin_user") {
      const superAdmins = await User.find({
        role: "super_admin",
      });

      for (const admin of superAdmins) {
        await createNotification({
          userId: admin._id,
          title: "User Baru",
          message: `${req.user.name} menambahkan user baru ${user.name}`,
          type: "account",
        });
      }
    }

    // Reseller membuat user
    if (req.user.role === "reseller") {
      const admin = await User.findById(req.user.ownerId);

      if (admin) {
        await createNotification({
          userId: admin._id,
          title: "User Baru",
          message: `${req.user.name} menambahkan user baru ${user.name}`,
          type: "account",
        });
      }
    }
    return res.status(201).json({
      success: true,
      message: "User berhasil dibuat",
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        ownerId: user.ownerId,
        createdBy: user.createdBy,
      },
    });
  } catch (error) {
    console.log("CREATE USER ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================
   DEACTIVATE USER
========================= */
const deactivateUser = async (req, res) => {
  try {
    // ambil id user
    const userId = req.params.id;

    // cari user
    const user = await User.findById(userId);

    // validasi
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // nonaktifkan user
    user.isActive = false;
    await user.save();

    return res.status(200).json({
      success: true,
      message: "User berhasil dinonaktifkan",
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================
   TRANSFER USER
========================= */
const transferUser = async (req, res) => {
  try {
    // =========================
    // HANYA SUPER ADMIN
    // BOLEH TRANSFER USER
    // =========================
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Hanya Super Admin yang dapat memindahkan user",
      });
    }

    const userId = req.params.id;
    const { newOwnerId } = req.body;
    console.log("=================================");
    console.log("TRANSFER USER");
    console.log("USER ID:", userId);
    console.log("NEW OWNER ID:", newOwnerId);
    console.log("LOGIN USER:", req.user._id);
    console.log("LOGIN ROLE:", req.user.role);
    console.log("=================================");

    // cari user target
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // cari owner baru
    const newOwner = await User.findOne({
      _id: newOwnerId,

      role: {
        $in: ["super_admin", "admin_user", "reseller"],
      },

      isActive: true,
    });
    console.log("NEW OWNER:", newOwner);

    if (!newOwner) {
      return res.status(404).json({
        success: false,
        message: "Owner baru tidak ditemukan",
      });
    }

    // pindahkan ownership
    user.ownerId = newOwner._id;

    await user.save();

    return res.status(200).json({
      success: true,
      message: "User berhasil dipindahkan",

      data: {
        userId: user._id,
        newOwnerId: newOwner._id,
      },
    });
  } catch (error) {
    console.log("TRANSFER USER ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================  
   EXTEND MODULE
========================= */
const extendModule = async (req, res) => {
  try {
    const userId = req.params.id;
    const { days } = req.body;

    // =========================
    // Validasi user tujuan
    // =========================
    const targetUser = await User.findById(userId);

    if (!targetUser || targetUser.role !== "user") {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // =========================
    // Validasi hari
    // =========================
    if (!days || isNaN(days) || days % 30 !== 0) {
      return res.status(400).json({
        success: false,
        message: "Perpanjangan hanya kelipatan 30 hari",
      });
    }

    // Coin yang dibutuhkan
    const requiredCoin = days / 30;

    // User login
    const loginUser = await User.findById(req.user._id);

    // =========================
    // SUPER ADMIN
    // bebas extend semua user
    // =========================
    if (loginUser.role === "super_admin") {
      // tidak melakukan apa-apa
    }

    // =========================
    // ADMIN USER
    // =========================
    else if (loginUser.role === "admin_user") {
      // cari reseller milik admin
      const resellerIds = await User.find({
        role: "reseller",
        ownerId: loginUser._id,
      }).distinct("_id");

      const bolehExtend =
        targetUser.ownerId.toString() === loginUser._id.toString() ||
        resellerIds.some(
          (id) => id.toString() === targetUser.ownerId.toString(),
        );

      if (!bolehExtend) {
        return res.status(403).json({
          success: false,
          message: "User bukan milik anda",
        });
      }

      if (loginUser.coinBalance < requiredCoin) {
        return res.status(400).json({
          success: false,
          message: "Saldo coin tidak mencukupi",
        });
      }

      // Kurangi coin
      loginUser.coinBalance -= requiredCoin;

      // Tambahkan jumlah pemakaian coin
      loginUser.usedCoinCounter =
        (loginUser.usedCoinCounter || 0) + requiredCoin;

      // Simpan perubahan
      await loginUser.save();
    }

    // =========================
    // RESELLER
    // =========================
    else if (loginUser.role === "reseller") {
      if (targetUser.ownerId.toString() !== loginUser._id.toString()) {
        return res.status(403).json({
          success: false,
          message: "User bukan milik anda",
        });
      }

      if (loginUser.coinBalance < requiredCoin) {
        return res.status(400).json({
          success: false,
          message: "Saldo coin tidak mencukupi",
        });
      }

      // Kurangi coin
      loginUser.coinBalance -= requiredCoin;

      // Tambahkan jumlah pemakaian coin
      loginUser.usedCoinCounter =
        (loginUser.usedCoinCounter || 0) + requiredCoin;

      await loginUser.save();
    }

    // =========================
    // Role lain
    // =========================
    else {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses",
      });
    }

    // =========================
    // Hitung masa aktif baru
    // =========================
    let currentDate = new Date();

    if (
      targetUser.moduleExpiredAt &&
      targetUser.moduleExpiredAt > currentDate
    ) {
      currentDate = new Date(targetUser.moduleExpiredAt);
    }

    const newExpiredDate = new Date(currentDate);
    newExpiredDate.setDate(newExpiredDate.getDate() + Number(days));

    targetUser.moduleExpiredAt = newExpiredDate;
    targetUser.paymentStatus = "active";
    targetUser.isActive = true;

    await targetUser.save();

    // Simpan riwayat transaksi
    await Transaction.create({
      // Jenis transaksi
      type: "module_extension",

      // User yang diperpanjang
      userId: targetUser._id,

      // Yang melakukan transaksi
      actorId: loginUser._id,

      // Coin yang dipakai
      coinUsed: requiredCoin,

      // Nominal transaksi (sementara isi sama dengan coin)
      amount: requiredCoin,

      // Lama perpanjangan
      durationDays: Number(days),

      // Langsung approved
      status: "approved",

      // Yang approve
      approvedBy: loginUser._id,

      approvedAt: new Date(),

      // Catatan
      notes: "Perpanjangan modul",
    });
    return res.status(200).json({
      success: true,
      message: "Module berhasil diperpanjang",
      data: {
        userId: targetUser._id,
        moduleExpiredAt: targetUser.moduleExpiredAt,
        coinBalance: loginUser.coinBalance,
      },
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Mengaktifkan kembali user
const activateUser = async (req, res) => {
  try {
    // Mengambil id user dari parameter URL
    const userId = req.params.id;

    // Mencari user
    const user = await User.findById(userId);

    // Jika user tidak ditemukan
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Mengaktifkan kembali user
    user.isActive = true;

    // Menyimpan perubahan
    await user.save();

    // Mengirim response berhasil
    return res.status(200).json({
      success: true,
      message: "User berhasil diaktifkan kembali",
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================
UPDATE USER
========================= */
const updateUser = async (req, res) => {
  try {
    const userId = req.params.id;

    const { name, email, phone } = req.body;

    // Cari user
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // =========================
    // VALIDASI EMAIL
    // =========================
    if (email && email !== user.email) {
      const existingUser = await User.findOne({
        email: email.trim(),
        _id: {
          $ne: user._id,
        },
      });

      if (existingUser) {
        return res.status(400).json({
          success: false,
          message: "Email sudah digunakan",
        });
      }

      user.email = email.trim();
    }

    // =========================
    // UPDATE DATA
    // =========================
    if (name && name.trim()) {
      user.name = name.trim();
    }

    if (phone !== undefined) {
      user.phone = phone.trim();
    }

    await user.save();

    return res.status(200).json({
      success: true,
      message: "User berhasil diperbarui",
      data: {
        _id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
      },
    });
  } catch (error) {
    console.log("UPDATE USER ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================
SUSPEND USER
========================= */
const suspendUser = async (req, res) => {
  try {
    const userId = req.params.id;

    // Cari user target
    const user = await User.findById(userId);

    if (!user || user.role !== "user") {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Ambil user yang sedang login
    const loginUser = await User.findById(req.user._id);

    if (!loginUser) {
      return res.status(401).json({
        success: false,
        message: "User login tidak ditemukan",
      });
    }

    // =========================
    // SUPER ADMIN
    // boleh suspend semua user
    // =========================
    if (loginUser.role === "super_admin") {
      // bebas
    }

    // =========================
    // ADMIN USER
    // boleh suspend:
    // 1. user miliknya sendiri
    // 2. user milik reseller di bawahnya
    // =========================
    else if (loginUser.role === "admin_user") {
      const resellerIds = await User.find({
        role: "reseller",
        ownerId: loginUser._id,
      }).distinct("_id");

      const bolehSuspend =
        user.ownerId &&
        (user.ownerId.toString() === loginUser._id.toString() ||
          resellerIds.some((id) => id.toString() === user.ownerId.toString()));

      if (!bolehSuspend) {
        return res.status(403).json({
          success: false,
          message: "User bukan bagian dari jaringan anda",
        });
      }
    }

    // =========================
    // RESELLER
    // hanya user miliknya
    // =========================
    else if (loginUser.role === "reseller") {
      if (
        !user.ownerId ||
        user.ownerId.toString() !== loginUser._id.toString()
      ) {
        return res.status(403).json({
          success: false,
          message: "User bukan milik anda",
        });
      }
    }

    // =========================
    // ROLE LAIN
    // =========================
    else {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses untuk suspend user",
      });
    }

    // =========================
    // SUSPEND
    // =========================

    user.accountStatus = "suspended";
    user.suspendedBy = loginUser._id;
    user.suspendedAt = new Date();
    user.suspendReason = req.body.reason?.trim() || "Suspend oleh admin";

    await user.save();

    return res.status(200).json({
      success: true,
      message: "User berhasil disuspend",
    });
  } catch (error) {
    console.log("SUSPEND USER ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================
ACTIVATE SUSPEND USER
========================= */
const activateSuspendUser = async (req, res) => {
  try {
    const userId = req.params.id;

    const user = await User.findById(userId);

    if (!user || user.role !== "user") {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    const loginUser = await User.findById(req.user._id);

    if (!loginUser) {
      return res.status(401).json({
        success: false,
        message: "User login tidak ditemukan",
      });
    }

    // =========================
    // SUPER ADMIN
    // =========================
    if (loginUser.role === "super_admin") {
      // bebas
    }

    // =========================
    // ADMIN USER
    // =========================
    else if (loginUser.role === "admin_user") {
      const resellerIds = await User.find({
        role: "reseller",
        ownerId: loginUser._id,
      }).distinct("_id");

      const bolehAktifkan =
        user.ownerId &&
        (user.ownerId.toString() === loginUser._id.toString() ||
          resellerIds.some((id) => id.toString() === user.ownerId.toString()));

      if (!bolehAktifkan) {
        return res.status(403).json({
          success: false,
          message: "User bukan bagian dari jaringan anda",
        });
      }
    }

    // =========================
    // RESELLER
    // =========================
    else if (loginUser.role === "reseller") {
      if (
        !user.ownerId ||
        user.ownerId.toString() !== loginUser._id.toString()
      ) {
        return res.status(403).json({
          success: false,
          message: "User bukan milik anda",
        });
      }
    }

    // =========================
    // ROLE LAIN
    // =========================
    else {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses",
      });
    }

    // =========================
    // CABUT SUSPEND
    // =========================

    user.accountStatus = "active";
    user.suspendedBy = null;
    user.suspendedAt = null;
    user.suspendReason = "";

    await user.save();

    return res.status(200).json({
      success: true,
      message: "Suspend user berhasil dicabut",
    });
  } catch (error) {
    console.log("ACTIVATE SUSPEND ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================
   RESET PASSWORD
   HANYA SUPER ADMIN
========================= */
const resetPassword = async (req, res) => {
  try {
    // =========================
    // CEK ROLE LOGIN
    // =========================
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Hanya Super Admin yang dapat reset password",
      });
    }

    const userId = req.params.id;
    const { password, confirmPassword } = req.body;

    // =========================
    // VALIDASI PASSWORD
    // =========================
    if (!password || !confirmPassword) {
      return res.status(400).json({
        success: false,
        message: "Password dan konfirmasi password wajib diisi",
      });
    }

    if (password !== confirmPassword) {
      return res.status(400).json({
        success: false,
        message: "Konfirmasi password tidak cocok",
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        message: "Password minimal 6 karakter",
      });
    }

    // =========================
    // CARI TARGET
    // =========================
    const targetUser = await User.findById(userId);

    if (!targetUser) {
      return res.status(404).json({
        success: false,
        message: "Akun tidak ditemukan",
      });
    }

    // =========================
    // SUPER ADMIN BOLEH RESET
    // ADMIN, RESELLER, USER
    // =========================
    if (!["admin_user", "reseller", "user"].includes(targetUser.role)) {
      return res.status(403).json({
        success: false,
        message: "Password akun ini tidak dapat direset",
      });
    }

    // =========================
    // HASH PASSWORD BARU
    // =========================
    const hashedPassword = await bcrypt.hash(password, 10);

    targetUser.password = hashedPassword;

    await targetUser.save();

    // =========================
    // RESPONSE
    // =========================
    return res.status(200).json({
      success: true,
      message: "Password berhasil direset",
    });
  } catch (error) {
    console.log("RESET PASSWORD ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

/* =========================
   EXPORT
========================= */
module.exports = {
  getUsers,
  getMyUsers,
  createUser,
  deactivateUser,
  transferUser,
  extendModule,
  activateUser,
  getUsersByAdmin,
  getUsersByReseller,
  updateUser,
  suspendUser,
  activateSuspendUser,
  resetPassword,
};
