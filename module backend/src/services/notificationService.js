const Notification = require("../models/Notification");

// 🔥 fungsi bikin notifikasi
const createNotification = async (userId, title, message, type = "system") => {
  try {
    const notif = await Notification.create({
      userId,
      title,
      message,
      type,
    });

    return notif;
  } catch (error) {
    console.log("Notification error:", error.message);
  }
};

module.exports = {
  createNotification,
};
