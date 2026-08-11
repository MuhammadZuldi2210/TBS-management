const mongoose = require("mongoose");

// Schema notifikasi
const notificationSchema = new mongoose.Schema(
  {
    // Penerima notifikasi
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    // Pengirim notifikasi
    // Bisa Super Admin, Admin, Reseller
    // Jika notifikasi otomatis dari sistem maka bernilai null
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    // Judul notifikasi
    title: {
      type: String,
      required: true,
      trim: true,
    },

    // Isi notifikasi
    message: {
      type: String,
      required: true,
      trim: true,
    },

    // Jenis notifikasi
    type: {
      type: String,
      enum: ["system", "coin", "bonus", "module", "transaction", "account"],
      default: "system",
    },

    // Status sudah dibaca atau belum
    isRead: {
      type: Boolean,
      default: false,
    },
  },
  {
    // Membuat createdAt & updatedAt otomatis
    timestamps: true,
  },
);

// Export model
module.exports = mongoose.model("Notification", notificationSchema);
