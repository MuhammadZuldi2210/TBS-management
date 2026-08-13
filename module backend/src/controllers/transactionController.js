// ======================================
// IMPORT MODEL
// ======================================

// Import model Transaction
const Transaction = require("../models/transactionModel");
const User = require("../models/User");

// ======================================
// GET ALL TRANSACTIONS
// ======================================

const getTransactions = async (req, res) => {
  try {
    let filter = {};

    // ===============================
    // FILTER JENIS TRANSAKSI
    // ===============================

    if (req.query.type) {
      filter.type = req.query.type;
    }

    // ===============================
    // FILTER STATUS
    // ===============================

    if (req.query.status) {
      filter.status = req.query.status;
    }

    // ===============================
    // PAGINATION
    // ===============================

    const page = Math.max(parseInt(req.query.page) || 1, 1);
    const limit = Math.min(Math.max(parseInt(req.query.limit) || 10, 1), 100);

    const skip = (page - 1) * limit;

    // ===============================
    // ROLE ACCESS
    // ===============================

    // SUPER ADMIN
    if (req.user.role === "super_admin") {
      filter.$or = [
        // Semua transaksi selain coin_purchase
        {
          type: {
            $ne: "coin_purchase",
          },
        },

        // Coin purchase yang ditujukan ke Super Admin
        {
          type: "coin_purchase",
          requestTo: req.user._id,
        },
      ];
    }

    // ADMIN
    else if (req.user.role === "admin_user") {
      filter.$or = [
        {
          actorId: req.user._id,
        },
        {
          requestTo: req.user._id,
        },
      ];
    }

    // RESELLER
    else if (req.user.role === "reseller") {
      filter.actorId = req.user._id;
    }

    // ROLE LAIN
    else {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses",
      });
    }

    // ===============================
    // HITUNG TOTAL
    // ===============================

    const total = await Transaction.countDocuments(filter);

    // ===============================
    // AMBIL TRANSAKSI SESUAI HALAMAN
    // ===============================

    const transactions = await Transaction.find(filter)
      .populate("userId", "name email phone")
      .populate("actorId", "name email role")
      .populate("requestTo", "name email role")
      .populate("approvedBy", "name role")
      .sort({
        createdAt: -1,
      })
      .skip(skip)
      .limit(limit);

    return res.status(200).json({
      success: true,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      data: transactions,
    });
  } catch (error) {
    console.log("GET TRANSACTIONS ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};
// ======================================
// DETAIL TRANSACTION
// ======================================

const getTransactionDetail = async (req, res) => {
  try {
    // Cari transaksi
    const transaction = await Transaction.findById(req.params.id)

      .populate("userId", "name email phone")

      .populate("actorId", "name email role")

      .populate("approvedBy", "name role");

    // Tidak ditemukan
    if (!transaction) {
      return res.status(404).json({
        success: false,

        message: "Transaksi tidak ditemukan",
      });
    }

    // Selain Super Admin:
    // Admin boleh melihat transaksi miliknya
    // atau request coin yang ditujukan kepadanya
    // Reseller hanya boleh melihat transaksi miliknya

    if (req.user.role === "admin_user") {
      const isActor =
        transaction.actorId &&
        transaction.actorId._id.toString() === req.user._id.toString();

      const isReceiver =
        transaction.requestTo &&
        transaction.requestTo.toString() === req.user._id.toString();

      if (!isActor && !isReceiver) {
        return res.status(403).json({
          success: false,
          message: "Tidak memiliki akses",
        });
      }
    } else if (
      req.user.role === "reseller" &&
      (!transaction.actorId ||
        transaction.actorId._id.toString() !== req.user._id.toString())
    ) {
      return res.status(403).json({
        success: false,
        message: "Tidak memiliki akses",
      });
    }

    return res.status(200).json({
      success: true,

      data: transaction,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,

      message: "Server Error",
    });
  }
};

// ======================================
// EXPORT CONTROLLER
// ======================================

module.exports = {
  getTransactions,
  getTransactionDetail,
};
