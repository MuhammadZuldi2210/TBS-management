const mongoose = require("mongoose");

// Schema transaksi
const transactionSchema = new mongoose.Schema(
  {
    // Jenis transaksi
    // module_extension = perpanjang modul
    // coin_purchase = request pembelian coin
    // coin_topup = topup coin langsung
    type: {
      type: String,
      enum: ["module_extension", "coin_purchase", "coin_topup"],
      required: true,
    },

    // User/member yang menjadi tujuan transaksi
    // Digunakan saat perpanjang modul
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    // Siapa yang melakukan transaksi
    // Bisa Super Admin, Admin, atau Reseller
    actorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    // Siapa yang menerima request coin
    requestTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    // Nominal transaksi (Rupiah)
    amount: {
      type: Number,
      required: true,
      min: 0,
    },

    // Jumlah coin yang dibeli / digunakan
    coinUsed: {
      type: Number,
      default: 0,
      min: 0,
    },

    // Lama perpanjangan modul (hari)
    durationDays: {
      type: Number,
      default: 0,
      min: 0,
    },

    // Status transaksi
    status: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },

    // Siapa yang menyetujui transaksi
    approvedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    // Waktu approval
    approvedAt: {
      type: Date,
      default: null,
    },

    // Catatan tambahan
    notes: {
      type: String,
      default: "",
      trim: true,
    },
  },

  {
    // Membuat createdAt & updatedAt otomatis
    timestamps: true,
  },
);

// Export model
module.exports = mongoose.model("Transaction", transactionSchema);
