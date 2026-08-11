// Import model User untuk berinteraksi dengan collection users di MongoDB
const User = require("../models/User");

// Import bcrypt untuk mengubah password menjadi hash
const bcrypt = require("bcryptjs");

// ==============================
// CREATE ADMIN
// ==============================

const createAdmin = async (req, res) => {
  try {
    // Mengambil data dari request
    const { name, email, password, phone } = req.body;

    // Validasi role
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Hanya Super Admin yang dapat menambahkan Admin",
      });
    }

    // Validasi input
    if (!name || !email || !password || !phone) {
      return res.status(400).json({
        success: false,
        message: "Semua field wajib diisi",
      });
    }

    // Cek email
    const existingEmail = await User.findOne({ email });

    if (existingEmail) {
      return res.status(400).json({
        success: false,
        message: "Email sudah digunakan",
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Membuat admin baru
    const admin = await User.create({
      name,
      email,
      password: hashedPassword,

      // Role Admin
      role: "admin_user",

      // Nomor Whatsapp
      phone,

      // Super Admin sebagai owner
      ownerId: req.user._id,

      // Dibuat oleh Super Admin
      createdBy: req.user._id,

      // Coin awal
      coinBalance: 0,

      // Admin selalu aktif
      isActive: true,

      // Tidak menggunakan sistem modul
      paymentStatus: "active",
      moduleExpiredAt: null,
    });

    // Response
    return res.status(201).json({
      success: true,
      message: "Admin berhasil ditambahkan",
      data: admin,
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
// GET LIST ADMIN
// ==============================

const getListAdmin = async (req, res) => {
  try {
    // Hanya Super Admin yang boleh melihat daftar Admin
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    // Mengambil query parameter
    const { search = "", page = 1, limit = 10 } = req.query;

    // Filter pencarian
    const filter = {
      role: "admin_user",
      $or: [
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
      ],
    };

    // Hitung total data
    const totalData = await User.countDocuments(filter);

    // Ambil daftar admin
    const admins = await User.find(filter)
      .select("-password")
      .sort({
        createdAt: -1,
      })
      .skip((page - 1) * limit)
      .limit(Number(limit));

    // Menambahkan statistik setiap admin
    const result = await Promise.all(
      admins.map(async (admin) => {
        // Hitung jumlah reseller milik admin
        const totalReseller = await User.countDocuments({
          role: "reseller",
          ownerId: admin._id,
        });

        // Hitung user langsung milik admin
        const totalDirectUser = await User.countDocuments({
          role: "user",
          ownerId: admin._id,
        });

        // Ambil seluruh reseller milik admin
        const resellerIds = await User.find({
          role: "reseller",
          ownerId: admin._id,
        }).select("_id");

        // Ambil array id reseller
        const ids = resellerIds.map((item) => item._id);

        // Hitung user milik reseller
        const totalResellerUser = await User.countDocuments({
          role: "user",
          ownerId: {
            $in: ids,
          },
        });

        return {
          _id: admin._id,
          name: admin.name,
          email: admin.email,
          phone: admin.phone,
          role: admin.role,
          coinBalance: admin.coinBalance,
          isActive: admin.isActive,
          accountStatus: admin.accountStatus,
          paymentStatus: admin.paymentStatus,
          createdAt: admin.createdAt,

          // jumlah reseller milik admin
          totalReseller,

          // user langsung dibuat admin
          totalDirectUser,

          // user milik reseller
          totalResellerUser,

          // total semua user dibawah admin
          totalUser: totalDirectUser,
        };
      }),
    );

    // Response
    return res.status(200).json({
      success: true,
      message: "Daftar Admin berhasil diambil",

      pagination: {
        currentPage: Number(page),
        totalPage: Math.ceil(totalData / limit),
        totalData,
      },

      data: result,
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
// GET DETAIL ADMIN
// ==============================

const getDetailAdmin = async (req, res) => {
  try {
    // Hanya Super Admin yang boleh melihat detail admin
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    // Mengambil id admin dari parameter URL
    const { id } = req.params;

    // Mencari admin
    const admin = await User.findOne({
      _id: id,
      role: "admin_user",
    }).select("-password");

    // Jika admin tidak ditemukan
    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    // Menghitung jumlah reseller milik admin
    const totalReseller = await User.countDocuments({
      role: "reseller",
      ownerId: admin._id,
    });

    // Mengambil daftar reseller milik admin
    const resellers = await User.find({
      role: "reseller",
      ownerId: admin._id,
    })
      .select("-password")
      .sort({
        createdAt: -1,
      });

    // Menghitung user langsung milik admin
    const totalDirectUser = await User.countDocuments({
      role: "user",
      ownerId: admin._id,
    });

    // Mengambil seluruh reseller milik admin
    const resellerIds = await User.find({
      role: "reseller",
      ownerId: admin._id,
    }).select("_id");

    // Mengubah menjadi array id
    const ids = resellerIds.map((item) => item._id);

    // Menghitung user milik reseller
    const totalResellerUser = await User.countDocuments({
      role: "user",
      ownerId: {
        $in: ids,
      },
    });

    // Total seluruh user
    const totalUser = totalDirectUser;

    // Response
    return res.status(200).json({
      success: true,
      message: "Detail Admin berhasil diambil",

      data: {
        _id: admin._id,
        name: admin.name,
        email: admin.email,
        phone: admin.phone,
        role: admin.role,
        coinBalance: admin.coinBalance,
        isActive: admin.isActive,
        accountStatus: admin.accountStatus,
        createdAt: admin.createdAt,
        updatedAt: admin.updatedAt,

        totalReseller,
        totalDirectUser,
        totalResellerUser,
        totalUser,
        resellers,
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
// GET RESELLER MILIK ADMIN
// ==============================

const getAdminResellers = async (req, res) => {
  try {
    // hanya super admin yang boleh melihat
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    const { id } = req.params;

    // cek admin
    const admin = await User.findOne({
      _id: id,
      role: "admin_user",
    });

    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    // ambil reseller milik admin
    const resellers = await User.find({
      role: "reseller",
      ownerId: id,
    })
      .select("-password")
      .sort({
        createdAt: -1,
      });

    return res.status(200).json({
      success: true,
      message: "Daftar reseller berhasil diambil",
      data: resellers,
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
// UPDATE ADMIN
// ==============================

const updateAdmin = async (req, res) => {
  try {
    // Hanya Super Admin yang boleh mengubah Admin
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    // Mengambil id admin dari parameter
    const { id } = req.params;

    // Mengambil data dari request
    const { name, email, phone } = req.body;

    // Mencari admin
    const admin = await User.findOne({
      _id: id,
      role: "admin_user",
    });

    // Jika admin tidak ditemukan
    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    // Jika email diubah
    if (email && email !== admin.email) {
      const existingEmail = await User.findOne({
        email,
        _id: {
          $ne: admin._id,
        },
      });

      // Jika email sudah digunakan
      if (existingEmail) {
        return res.status(400).json({
          success: false,
          message: "Email sudah digunakan",
        });
      }
    }

    // Update data
    admin.name = name ?? admin.name;
    admin.email = email ?? admin.email;
    admin.phone = phone ?? admin.phone;

    // Simpan perubahan
    await admin.save();

    // Response
    return res.status(200).json({
      success: true,
      message: "Admin berhasil diperbarui",
      data: {
        _id: admin._id,
        name: admin.name,
        email: admin.email,
        phone: admin.phone,
        role: admin.role,
        coinBalance: admin.coinBalance,
        isActive: admin.isActive,
        updatedAt: admin.updatedAt,
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
// ACTIVATE ADMIN
// ==============================

const activateAdmin = async (req, res) => {
  try {
    // Hanya Super Admin yang boleh mengaktifkan Admin
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    // Mengambil id admin
    const { id } = req.params;

    // Mencari admin
    const admin = await User.findOne({
      _id: id,
      role: "admin_user",
    });

    // Jika admin tidak ditemukan
    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    // Mengaktifkan kembali admin suspend
    admin.accountStatus = "active";

    admin.isActive = true;

    admin.suspendedBy = null;

    admin.suspendedAt = null;

    admin.suspendReason = "";

    // Simpan perubahan
    await admin.save();

    // Response
    return res.status(200).json({
      success: true,
      message: "Admin berhasil diaktifkan",
      data: admin,
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
// DEACTIVATE ADMIN
// ==============================

const deactivateAdmin = async (req, res) => {
  try {
    // Hanya Super Admin yang boleh menonaktifkan Admin
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    // Mengambil id admin
    const { id } = req.params;

    // Mencari admin
    const admin = await User.findOne({
      _id: id,
      role: "admin_user",
    });

    // Jika admin tidak ditemukan
    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    // Mencegah Super Admin menonaktifkan dirinya sendiri
    if (admin._id.toString() === req.user._id.toString()) {
      return res.status(400).json({
        success: false,
        message: "Tidak dapat menonaktifkan akun sendiri",
      });
    }

    // Jika sudah nonaktif
    if (!admin.isActive) {
      return res.status(400).json({
        success: false,
        message: "Admin sudah dinonaktifkan",
      });
    }

    // Menonaktifkan admin
    admin.isActive = false;

    // Simpan perubahan
    await admin.save();

    // Response
    return res.status(200).json({
      success: true,
      message: "Admin berhasil dinonaktifkan",
      data: admin,
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
// GET OWNER TRANSFER
// ==============================

const getTransferOwners = async (req, res) => {
  try {
    if (req.user.role !== "super_admin") {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak",
      });
    }

    const owners = await User.find({
      role: {
        $in: ["super_admin", "admin_user", "reseller"],
      },
      isActive: true,
    })
      .select("name role")
      .sort({
        role: 1,
        name: 1,
      });

    return res.status(200).json({
      success: true,
      data: owners,
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
// SUSPEND ADMIN
// ==============================

const suspendAdmin = async (req, res) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;

    const admin = await User.findOne({
      _id: id,
      role: "admin_user",
    });

    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    // tidak boleh suspend diri sendiri
    if (admin._id.toString() === req.user._id.toString()) {
      return res.status(400).json({
        success: false,
        message: "Tidak dapat suspend akun sendiri",
      });
    }

    admin.accountStatus = "suspended";
    admin.isActive = false;

    admin.suspendReason = reason || "";

    await admin.save();

    return res.status(200).json({
      success: true,
      message: "Admin berhasil disuspend",
      data: admin,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};
module.exports = {
  createAdmin,
  getListAdmin,
  getDetailAdmin,
  getAdminResellers,
  updateAdmin,
  activateAdmin,
  deactivateAdmin,
  getTransferOwners,
  suspendAdmin,
};
