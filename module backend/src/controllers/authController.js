// Mengimpor model User
const User = require("../models/User");

// Meimport token JWT SECRET
const jwt = require("jsonwebtoken");

// Mengimpor bcrypt
const bcrypt = require("bcryptjs");

// REGISTER USER
const registerUser = async (req, res) => {
  try {
    const { name, email, password, phone, ownerId } = req.body;

    // Validasi data wajib
    if (!name || !email || !password || !phone || !ownerId) {
      return res.status(400).json({
        success: false,
        message: "Semua field wajib diisi",
      });
    }

    // cek email sudah dipakai atau belum
    const existingUser = await User.findOne({ email });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: "Email sudah digunakan",
      });
    }

    // Mencari owner berdasarkan ownerId
    const owner = await User.findOne({
      // ID owner yang dipilih saat registrasi
      _id: ownerId,

      // Owner dapat berupa super admin atau admin user
      role: {
        $in: ["super_admin", "admin_user", "reseller"],
      },

      // Owner harus aktif
      isActive: true,
    });

    // Jika owner tidak ditemukan
    if (!owner) {
      return res.status(404).json({
        success: false,
        message: "Owner tidak ditemukan",
      });
    }

    // hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // buat user baru
    const user = await User.create({
      name,
      email,
      password: hashedPassword,
      role: "user",
      ownerId,
      phone,
      createdBy: ownerId,
      paymentStatus: "pending",
      moduleExpiredAt: null,
      coinBalance: 0,
      isActive: true,
    });
    // Mengirim response berhasil
    return res.status(201).json({
      success: true,
      message: "registrasi berhasil",
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        paymentStatus: user.paymentStatus,
        ownerId: user.ownerId,
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

// Login user
const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log("Email login:", email);

    // cek user
    const user = await User.findOne({ email });
    console.log("User ditemukan:", !!user);

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Email salah",
      });
    }
    // cek password
    const isMatch = await bcrypt.compare(
      String(password),
      String(user.password),
    );
    console.log("Password cocok:", isMatch);

    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: "Password salah",
      });
    }

    // Cek apakah akun disuspend
    if (user.accountStatus === "suspended") {
      return res.status(403).json({
        success: false,
        message: "Akun Anda telah disuspend",
      });
    }

    // Cek apakah akun dinonaktifkan
    if (!user.isActive) {
      return res.status(403).json({
        success: false,
        message: "Akun Anda tidak aktif",
      });
    }

    // Buat token JWT
    const token = jwt.sign(
      {
        id: user._id,
        role: user.role,
      },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      },
    );

    return res.status(200).json({
      success: true,
      message: "Login berhasil",
      token,
      user: {
        _id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        paymentStatus: user.paymentStatus,
        moduleExpiredAt: user.moduleExpiredAt,
        ownerId: user.ownerId,
        coinBalance: user.coinBalance,
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

// Mengambil data user yg sedang login
const getProfile = async (req, res) => {
  try {
    return res.status(200).json({
      success: true,
      message: "profile berhasil diambil",
      user: req.user,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Mengambil daftar owner yang aktif
const getAdminList = async (req, res) => {
  try {
    // Mengambil semua owner yang masih aktif
    const owners = await User.find({
      // Owner dapat berupa super admin atau admin user
      role: {
        $in: ["super_admin", "admin_user", "reseller"],
      },

      // Hanya owner yang aktif
      isActive: true,
    })

      // Hanya mengambil field yang dibutuhkan frontend
      .select("_id name phone role");

    // Mengirim daftar owner ke frontend
    return res.status(200).json({
      success: true,
      data: owners,
    });
  } catch (error) {
    // Menampilkan error di terminal server
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Update profile user yg sedang login
const updateProfile = async (req, res) => {
  try {
    // Mengambil data dari body request
    const { name, email, phone } = req.body;

    // Mengambil id user dari middleware protect
    const userId = req.user._id;

    // Mencari user berdasarkan id
    const user = await User.findById(userId);

    // Jika user tidak ditemukan
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Jika email diubah, cek apakah email sudah dipakai user lain
    if (email && email !== user.email) {
      // Mencari email yang sama selain milik user saat ini
      const existingEmail = await User.findOne({
        email,
        _id: { $ne: userId },
      });

      // Jika email sudah digunakan
      if (existingEmail) {
        return res.status(400).json({
          success: false,
          message: "Email sudah digunakan",
        });
      }
    }

    // Update data profile
    user.name = name || user.name;
    user.email = email || user.email;
    user.phone = phone || user.phone;

    // Simpan perubahan ke database
    await user.save();

    // Mengirim response berhasil
    return res.status(200).json({
      success: true,
      message: "Profile berhasil diperbarui",
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
      },
    });
  } catch (error) {
    // Menampilkan error ke terminal
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// Mengubah password user yang sedang login
const changePassword = async (req, res) => {
  try {
    // Mengambil password lama dan password baru dari request
    const { oldPassword, newPassword } = req.body;

    // Validasi input wajib
    if (!oldPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        message: "Password lama dan password baru wajib diisi",
      });
    }

    // Mengambil user yang sedang login beserta password
    const user = await User.findById(req.user._id);

    // Jika user tidak ditemukan
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Membandingkan password lama dengan password di database
    const isMatch = await bcrypt.compare(oldPassword, user.password);

    // Jika password lama salah
    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: "Password lama salah",
      });
    }

    // Melakukan hash password baru
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Menyimpan password baru ke database
    user.password = hashedPassword;

    // Menyimpan perubahan
    await user.save();

    // Mengirim response berhasil
    return res.status(200).json({
      success: true,
      message: "Password berhasil diubah",
    });
  } catch (error) {
    // Menampilkan error ke terminal
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// EXPORT WAJIB
module.exports = {
  registerUser,
  loginUser,
  getProfile,
  getAdminList,
  updateProfile,
  changePassword,
};
