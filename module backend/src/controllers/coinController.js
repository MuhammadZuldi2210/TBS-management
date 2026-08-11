// ===============================================
// IMPORT MODEL
// ===============================================

// Import model User
const User = require("../models/User");

// Import model Transaction
const Transaction = require("../models/transactionModel");

// Import createNotifaction
const createNotification = require("../utils/createNotification");

// ===============================================
// TOPUP COIN
// SUPER ADMIN -> ADMIN / RESELLER
// ===============================================

const topupCoin = async (req, res) => {
  try {
    // Ambil data request
    const { userId, amount } = req.body;

    // Validasi
    if (!userId || !amount) {
      return res.status(400).json({
        success: false,
        message: "userId dan amount wajib diisi",
      });
    }

    // ======================================
    // CEK HAK AKSES TOPUP
    // ======================================

    let user;

    // Super Admin
    if (req.user.role === "super_admin") {
      user = await User.findOne({
        _id: userId,
        role: {
          $in: ["admin_user", "reseller"],
        },
        isActive: true,
      });
    }

    // Reseller
    else {
      return res.status(403).json({
        success: false,
        message: "Anda tidak memiliki akses topup coin",
      });
    }

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan atau bukan milik Anda",
      });
    }

    // Jumlah coin yang dibeli
    const topupAmount = Number(amount);

    // Tambahkan coin sesuai pembelian saja
    user.coinBalance += topupAmount;

    await user.save();
    // Simpan transaksi
    await Transaction.create({
      type: "coin_topup",

      actorId: req.user._id,

      userId: user._id,

      amount: topupAmount,

      coinUsed: topupAmount,

      status: "approved",

      approvedBy: req.user._id,

      approvedAt: new Date(),
    });

    // Kirim notifikasi
    await createNotification({
      userId: user._id,
      title: "Topup Coin",
      message: `${topupAmount} coin berhasil ditambahkan ke akun Anda.`,
      type: "coin",
    });

    return res.status(200).json({
      success: true,
      message: "Topup coin berhasil",
      data: {
        userId: user._id,
        name: user.name,
        role: user.role,

        topupCoin: topupAmount,

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

// ===============================================
// GET BALANCE
// ===============================================

const getBalance = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    return res.status(200).json({
      success: true,
      data: {
        userId: user._id,
        name: user.name,
        role: user.role,
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

// ===============================================
// REQUEST COIN
// ADMIN -> SUPER ADMIN
// RESELLER -> ADMIN PEMILIK / SUPER ADMIN
// ===============================================

const requestCoin = async (req, res) => {
  try {
    // ==========================================
    // CEK ROLE
    // ==========================================

    if (req.user.role !== "admin_user" && req.user.role !== "reseller") {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses",
      });
    }

    // Ambil data request
    const { amount, requestTo, notes } = req.body;

    // ==========================================
    // VALIDASI JUMLAH COIN
    // ==========================================

    if (!amount) {
      return res.status(400).json({
        success: false,
        message: "Jumlah coin wajib diisi",
      });
    }

    if (Number(amount) <= 0) {
      return res.status(400).json({
        success: false,
        message: "Jumlah coin harus lebih dari 0",
      });
    }

    // requestTo wajib ada
    if (!requestTo) {
      return res.status(400).json({
        success: false,
        message: "Tujuan request wajib dipilih",
      });
    }

    // ==========================================
    // CARI PENERIMA
    // ==========================================

    const receiver = await User.findById(requestTo);

    if (!receiver || !receiver.isActive) {
      return res.status(404).json({
        success: false,
        message: "Penerima request tidak ditemukan",
      });
    }

    // ==========================================
    // ADMIN
    // HANYA BOLEH REQUEST KE SUPER ADMIN
    // ==========================================

    if (req.user.role === "admin_user") {
      if (receiver.role !== "super_admin") {
        return res.status(403).json({
          success: false,
          message: "Admin hanya dapat request coin ke Super Admin",
        });
      }
    }

    // ==========================================
    // RESELLER
    // BOLEH REQUEST KE:
    // 1. ADMIN PEMILIK
    // 2. SUPER ADMIN
    // ==========================================

    if (req.user.role === "reseller") {
      // Reseller harus memiliki owner
      if (!req.user.ownerId) {
        return res.status(400).json({
          success: false,
          message: "Admin pemilik reseller tidak ditemukan",
        });
      }

      // ========================================
      // PILIH SUPER ADMIN
      // ========================================

      if (receiver.role === "super_admin") {
        // Boleh
      }

      // ========================================
      // PILIH ADMIN PEMILIK
      // ========================================
      else if (receiver.role === "admin_user") {
        // Pastikan admin adalah owner reseller
        if (receiver._id.toString() !== req.user.ownerId.toString()) {
          return res.status(403).json({
            success: false,
            message: "Reseller hanya dapat request ke Admin pemiliknya",
          });
        }
      }

      // ========================================
      // ROLE LAIN
      // ========================================
      else {
        return res.status(403).json({
          success: false,
          message:
            "Reseller hanya dapat request ke Admin pemilik atau Super Admin",
        });
      }
    }

    // ==========================================
    // HARGA COIN
    // ==========================================

    const coinPrice = 100000;

    const totalAmount = Number(amount) * coinPrice;

    // ==========================================
    // SIMPAN TRANSAKSI
    // ==========================================

    const transaction = await Transaction.create({
      type: "coin_purchase",

      // Yang melakukan request
      actorId: req.user._id,

      // Tujuan request
      requestTo: receiver._id,

      // Total harga
      amount: totalAmount,

      // Jumlah coin
      coinUsed: Number(amount),

      // Status
      status: "pending",

      notes: notes || "",
    });

    // ==========================================
    // NOTIFICATION KE PENERIMA
    // ==========================================

    await createNotification({
      userId: receiver._id,

      title: "Request Coin Baru",

      message: `${req.user.name} meminta pembelian ${amount} coin.`,

      type: "coin",
    });

    // ==========================================
    // RESPONSE
    // ==========================================

    return res.status(201).json({
      success: true,

      message: "Request coin berhasil dibuat",

      data: transaction,
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
// GET PENDING REQUEST
// SUPER ADMIN
// ===============================================

const getPendingRequests = async (req, res) => {
  try {
    // Filter request
    const filter = {
      type: "coin_purchase",
      status: "pending",
      requestTo: req.user._id,
    };

    // Ambil request
    const requests = await Transaction.find(filter)
      .populate("actorId", "name email role phone coinBalance")
      .populate("requestTo", "name role")
      .sort({
        createdAt: -1,
      });

    return res.status(200).json({
      success: true,
      total: requests.length,
      data: requests,
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
// APPROVE REQUEST COIN
// SUPER ADMIN
// ===============================================

const approveCoinRequest = async (req, res) => {
  try {
    // Ambil id transaksi
    const { id } = req.params;

    // Cari transaksi
    const transaction = await Transaction.findById(id);

    if (!transaction) {
      return res.status(404).json({
        success: false,
        message: "Transaksi tidak ditemukan",
      });
    }

    // Pastikan hanya penerima request yang bisa approve
    if (
      !transaction.requestTo ||
      transaction.requestTo.toString() !== req.user._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Anda tidak memiliki akses untuk menyetujui transaksi ini",
      });
    }
    // Validasi jenis transaksi
    if (transaction.type !== "coin_purchase") {
      return res.status(400).json({
        success: false,
        message: "Bukan transaksi pembelian coin",
      });
    }

    // Validasi status
    if (transaction.status !== "pending") {
      return res.status(400).json({
        success: false,
        message: "Transaksi sudah diproses",
      });
    }

    // Cari user yang request coin
    const user = await User.findById(transaction.actorId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    // Cari pemberi coin
    const receiver = await User.findById(transaction.requestTo);

    if (!receiver) {
      return res.status(404).json({
        success: false,
        message: "Pemberi coin tidak ditemukan",
      });
    }

    // Jumlah coin yang dibeli
    const purchasedCoin = Number(transaction.coinUsed);

    // Total coin yang sudah dipakai
    const usedCoin = Number(user.usedCoinCounter || 0);

    // Bonus
    let bonusCoin = 0;

    // Jika sudah memakai minimal 5 coin
    if (usedCoin >= 5) {
      bonusCoin = Math.floor(usedCoin / 5);

      // Reset counter sesuai bonus yang sudah diberikan
      user.usedCoinCounter = usedCoin % 5;
    }

    // Tambahkan saldo
    // Jika request ke Admin User
    // maka coin admin berkurang
    if (receiver.role === "admin_user") {
      if (receiver.coinBalance < purchasedCoin) {
        return res.status(400).json({
          success: false,
          message: "Saldo coin anda tidak mencukupi isi ulang coin dulu",
        });
      }

      receiver.coinBalance -= purchasedCoin;

      await receiver.save();
    }

    // Jika request ke Super Admin
    // tidak ada pengurangan coin

    // Tambahkan coin ke requester
    user.coinBalance += purchasedCoin + bonusCoin;

    await user.save();

    // Update transaksi
    transaction.status = "approved";
    transaction.approvedBy = req.user._id;
    transaction.approvedAt = new Date();

    await transaction.save();

    // Notification
    await createNotification({
      userId: user._id,
      title: "Topup Coin Disetujui",
      message: `${purchasedCoin} coin berhasil masuk ke akun Anda.`,
      type: "coin",
    });

    // Notifaction bonus
    if (bonusCoin > 0) {
      await createNotification({
        userId: user._id,
        title: "Bonus Coin",
        message: `Selamat! Anda mendapatkan bonus ${bonusCoin} coin dari 5 coin yg sudah anda gunakan.`,
        type: "bonus",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Topup coin berhasil",
      data: {
        userId: user._id,
        name: user.name,
        role: user.role,

        topupCoin: purchasedCoin,
        bonusCoin,
        coinBalance: user.coinBalance,
        usedCoinCounter: user.usedCoinCounter,
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

// ===============================================
// HISTORY COIN
// ===============================================

const getCoinHistory = async (req, res) => {
  try {
    let filter = {
      type: {
        $in: ["coin_purchase", "coin_topup"],
      },
    };

    // Admin hanya melihat history miliknya
    if (req.user.role === "admin_user" || req.user.role === "reseller") {
      filter.actorId = req.user._id;
    }

    const history = await Transaction.find(filter)
      .populate("actorId", "name email role phone")
      .populate("requestTo", "name role")
      .populate("approvedBy", "name role")
      .sort({
        createdAt: -1,
      });

    return res.status(200).json({
      success: true,
      total: history.length,
      data: history,
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
// EXPORT CONTROLLER
// ===============================================

module.exports = {
  topupCoin,
  getBalance,
  requestCoin,
  getPendingRequests,
  approveCoinRequest,
  getCoinHistory,
};
