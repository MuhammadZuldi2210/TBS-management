const mongoose = require("mongoose");

// Fungsi untuk menghubungkan backend ke MongoDB
const connectDatabase = async () => {
  try {
    // Melakukan koneksi ke MongoDB menggunakan MONGO_URI dari .env
    await mongoose.connect(process.env.MONGO_URI);

    console.log("MongoDB berhasil terhubung");
  } catch (error) {
    console.error("MongoDB gagal terhubung");
    console.error(error.message);

    // Menghentikan aplikasi jika database gagal terkoneksi
    process.exit(1);
  }
};

// Mengekspor fungsi agar bisa dipakai di file lain
module.exports = connectDatabase;
