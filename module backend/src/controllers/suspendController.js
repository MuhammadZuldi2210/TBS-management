// ===============================================
// IMPORT MODEL
// ===============================================

// Import model User
const User = require("../models/User");

// Import notification
const createNotification = require("../utils/createNotification");

// ===============================================
// CHECK PERMISSION SUSPEND / ACTIVATE
// ===============================================

const checkSuspendPermission = async (currentUser, targetUser) => {
  // Tidak boleh suspend / activate diri sendiri
  if (targetUser._id.toString() === currentUser._id.toString()) {
    return false;
  }

  //--------------------------------------------------
  // SUPER ADMIN
  //--------------------------------------------------

  if (currentUser.role === "super_admin") {
    return ["admin_user", "reseller", "user"].includes(targetUser.role);
  }

  //--------------------------------------------------
  // ADMIN
  //--------------------------------------------------

  if (currentUser.role === "admin_user") {
    // Reseller miliknya
    if (targetUser.role === "reseller") {
      return targetUser.ownerId.toString() === currentUser._id.toString();
    }

    // User langsung milik admin
    if (targetUser.role === "user") {
      if (targetUser.ownerId.toString() === currentUser._id.toString()) {
        return true;
      }

      // User milik reseller yang dimiliki admin
      const reseller = await User.findById(targetUser.ownerId);

      return (
        reseller &&
        reseller.role === "reseller" &&
        reseller.ownerId.toString() === currentUser._id.toString()
      );
    }

    return false;
  }

  //--------------------------------------------------
  // RESELLER
  //--------------------------------------------------

  if (currentUser.role === "reseller") {
    return (
      targetUser.role === "user" &&
      targetUser.ownerId.toString() === currentUser._id.toString()
    );
  }

  return false;
};

// ===============================================
// SUSPEND USER
// ===============================================

const suspendUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;

    // Cari user yang akan disuspend
    const targetUser = await User.findById(id);

    if (!targetUser) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Cek permission
    const allowed = await checkSuspendPermission(req.user, targetUser);

    if (!allowed) {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses",
      });
    }

    //--------------------------------------------------
    // SUSPEND USER
    //--------------------------------------------------

    // ubah status akun menjadi suspend
    targetUser.accountStatus = "suspended";

    // matikan akses login
    targetUser.isActive = false;

    // simpan siapa yang melakukan suspend
    targetUser.suspendedBy = req.user._id;

    // waktu suspend
    targetUser.suspendedAt = new Date();

    // alasan suspend
    targetUser.suspendReason = reason || "";

    await targetUser.save();

    // Kirim notifikasi
    await createNotification({
      userId: targetUser._id,
      title: "Akun Disuspend",
      message:
        reason || "Akun Anda telah disuspend. Silakan hubungi administrator.",
      type: "account",
    });

    return res.status(200).json({
      success: true,
      message: "Akun berhasil disuspend",
      data: targetUser,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// ===============================================
// AKTIFKAN KEMBALI AKUN
// ===============================================

const activateUser = async (req, res) => {
  try {
    const { id } = req.params;

    // Cari user
    const targetUser = await User.findById(id);

    if (!targetUser) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Cek permission
    const allowed = await checkSuspendPermission(req.user, targetUser);

    if (!allowed) {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses",
      });
    }

    // Aktifkan kembali akun
    // Aktifkan kembali akun
    targetUser.accountStatus = "active";

    targetUser.isActive = true;

    targetUser.suspendedBy = null;

    targetUser.suspendedAt = null;

    targetUser.suspendReason = "";

    await targetUser.save();

    // Kirim notifikasi
    await createNotification({
      userId: targetUser._id,
      title: "Akun Diaktifkan",
      message: "Akun Anda telah diaktifkan kembali.",
      type: "account",
    });

    return res.status(200).json({
      success: true,
      message: "Akun berhasil diaktifkan",
      data: targetUser,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// ===============================================
// EXPORT
// ===============================================

module.exports = {
  suspendUser,
  activateUser,
};
