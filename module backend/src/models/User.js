const mongoose = require("mongoose");

// Schema untuk seluruh jenis akun di sistem
const userSchema = new mongoose.Schema(
  {
    // Nama lengkap pengguna
    name: {
      type: String,
      required: true,
      trim: true,
    },

    // Email untuk login
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },

    // Password yang sudah di-hash menggunakan bcrypt
    password: {
      type: String,
      required: true,
    },

    // Role pengguna dalam sistem
    // Super Admin = akses penuh
    // Admin = mengelola reseller & user
    // Reseller = mengelola user
    // User = hanya data member (tidak bisa login)
    role: {
      type: String,
      enum: ["super_admin", "admin_user", "reseller", "user"],
      required: true,
    },

    // Menyimpan siapa yang membuat akun ini
    // Contoh:
    // Admin dibuat Super Admin
    // Reseller dibuat Admin
    // User dibuat Reseller/Admin/Super Admin
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    // Menyimpan pemilik akun
    // Digunakan untuk filtering dashboard
    ownerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    // Saldo coin
    // Digunakan oleh Admin & Reseller
    coinBalance: {
      type: Number,
      default: 0,
    },

    // Menghitung jumlah coin yang sudah dipakai
    usedCoinCounter: {
      type: Number,
      default: 0,
    },

    // Nomor WhatsApp
    phone: {
      type: String,
      trim: true,
      default: null,
    },

    // Status pembayaran modul
    paymentStatus: {
      type: String,
      enum: ["pending", "active", "expired"],
      default: "pending",
    },

    // Masa aktif modul
    moduleExpiredAt: {
      type: Date,
      default: null,
    },

    // Status akun
    isActive: {
      type: Boolean,
      default: true,
    },

    // ===============================================
    // STATUS SUSPEND AKUN
    // ===============================================

    // Status akun
    accountStatus: {
      type: String,
      enum: ["active", "suspended"],
      default: "active",
    },

    // Siapa yang melakukan suspend
    suspendedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    // Waktu suspend
    suspendedAt: {
      type: Date,
      default: null,
    },

    // Alasan suspend
    suspendReason: {
      type: String,
      default: "",
    },
  },

  {
    // Membuat createdAt & updatedAt otomatis
    timestamps: true,
  },
);

// ==========================================
// INDEX MONGODB
// ==========================================

// Untuk query berdasarkan role + user terbaru
userSchema.index({
  role: 1,
  createdAt: -1,
});

// Untuk query berdasarkan owner + role + user terbaru
userSchema.index({
  ownerId: 1,
  role: 1,
  createdAt: -1,
});

// Membuat model User
const User = mongoose.model("User", userSchema);

// Export model
module.exports = User;
