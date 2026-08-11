// Mengimpor dotenv agar bisa membaca file .env
require("dotenv").config();

// Mengimpor mongoose
const mongoose = require("mongoose");

// Mengimpor model User
const User = require("../models/User");

// Menghubungkan ke MongoDB
mongoose
  .connect(process.env.MONGO_URI)
  .then(async () => {
    console.log("MongoDB berhasil terhubung");

    // Membuat super admin pertama
    const superAdmin = await User.create({
      // Nama super admin
      name: "zuldi",

      // Email untuk login
      email: "zuldiputratanjung2210@gmail,com",

      // Untuk sementara password belum di hash
      password: "221098",

      // Role super admin
      role: "super_admin",

      // Super admin awal memiliki coin 0
      coinBalance: 0,
    });

    console.log("Super Admin berhasil dibuat");
    console.log(superAdmin);

    // Menutup koneksi database
    mongoose.connection.close();
  })
  .catch((error) => {
    console.log(error.message);
  });
