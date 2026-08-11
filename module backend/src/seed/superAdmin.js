const User = require("../models/User");
const bcrypt = require("bcryptjs");

const createSuperAdmin = async () => {
  try {
    const existing = await User.findOne({ role: "super_admin" });

    if (existing) {
      console.log("Super admin sudah ada");
      return;
    }

    const hashedPassword = await bcrypt.hash("221098", 10);

    await User.create({
      name: "Zuldi",
      email: "zuldiputratanjung2210@gmail.com",
      password: hashedPassword,
      role: "super_admin",
      ownerId: null,
      isActive: true,
    });

    console.log("Super admin berhasil dibuat");
  } catch (error) {
    console.log("Seed error:", error);
  }
};

module.exports = createSuperAdmin;
