// ===============================================
// IMPORT MODEL
// ===============================================

const Notification = require("../models/Notification");

// ===============================================
// CREATE NOTIFICATION
// ===============================================

const createNotification = async ({
  userId,
  createdBy = null,
  title,
  message,
  type = "info",
}) => {
  try {
    await Notification.create({
      userId,
      createdBy,
      title,
      message,
      type,
    });
  } catch (error) {
    console.error("Notification Error:", error.message);
  }
};

// ===============================================
// EXPORT
// ===============================================

module.exports = createNotification;
