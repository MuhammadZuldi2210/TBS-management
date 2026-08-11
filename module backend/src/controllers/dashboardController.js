// ===============================================
// IMPORT MODEL
// ===============================================

// Import model User
const User = require("../models/User");

// Import model Transaction
const Transaction = require("../models/transactionModel");

// ===============================================
// DASHBOARD SUPER ADMIN
// ===============================================

const getSuperAdminStats = async (req, res) => {
  try {
    // Total Admin
    const totalAdmins = await User.countDocuments({
      role: "admin_user",
    });

    // Total Reseller
    const totalResellers = await User.countDocuments({
      role: "reseller",
    });

    // Total seluruh user
    const totalUsers = await User.countDocuments({
      role: "user",
    });

    // Total user milik Super Admin
    const totalMyUsers = await User.countDocuments({
      role: "user",
      ownerId: req.user._id,
    });

    // User aktif
    const activeUsers = await User.countDocuments({
      role: "user",
      paymentStatus: "active",
    });

    // User expired
    const expiredUsers = await User.countDocuments({
      role: "user",
      paymentStatus: "expired",
    });

    // User pending
    const pendingUsers = await User.countDocuments({
      role: "user",
      paymentStatus: "pending",
    });

    // User aktif milik Super Admin
    const activeMyUsers = await User.countDocuments({
      role: "user",
      ownerId: req.user._id,
      paymentStatus: "active",
    });

    // Total transaksi
    const totalTransactions = await Transaction.countDocuments();

    // Request coin pending
    const pendingCoinRequests = await Transaction.countDocuments({
      type: "coin_purchase",
      status: "pending",
    });

    // Approved transaksi
    const approvedTransactions = await Transaction.countDocuments({
      status: "approved",
    });

    // Rejected transaksi
    const rejectedTransactions = await Transaction.countDocuments({
      status: "rejected",
    });

    // Total revenue
    const revenueResult = await Transaction.aggregate([
      {
        $match: {
          status: "approved",
        },
      },
      {
        $group: {
          _id: null,
          totalRevenue: {
            $sum: "$amount",
          },
        },
      },
    ]);

    return res.status(200).json({
      success: true,
      data: {
        totalAdmins,
        totalResellers,

        totalUsers,
        totalMyUsers,

        activeUsers,
        activeMyUsers,

        expiredUsers,
        pendingUsers,

        totalTransactions,

        pendingCoinRequests,

        approvedTransactions,
        rejectedTransactions,

        totalRevenue: revenueResult[0]?.totalRevenue || 0,
      },
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ===============================================
// GET ALL ADMINS
// ===============================================

const getAllAdmins = async (req, res) => {
  try {
    // Ambil seluruh admin
    const admins = await User.find({
      role: "admin_user",
    })
      .select("-password")
      .sort({
        createdAt: -1,
      });

    // Tambahkan statistik
    const result = await Promise.all(
      admins.map(async (admin) => {
        // Hitung reseller milik admin
        const totalReseller = await User.countDocuments({
          role: "reseller",
          ownerId: admin._id,
        });

        // Hitung user langsung milik admin
        const totalDirectUser = await User.countDocuments({
          role: "user",
          ownerId: admin._id,
        });

        // Ambil reseller milik admin
        const resellerIds = await User.find({
          role: "reseller",
          ownerId: admin._id,
        }).select("_id");

        // Array id reseller
        const ids = resellerIds.map((item) => item._id);

        // Hitung user reseller
        const totalResellerUser = await User.countDocuments({
          role: "user",
          ownerId: {
            $in: ids,
          },
        });

        return {
          _id: admin._id,

          name: admin.name,
          email: admin.email,
          phone: admin.phone,

          coinBalance: admin.coinBalance,

          isActive: admin.isActive,

          createdAt: admin.createdAt,

          totalReseller,

          totalDirectUser,

          totalResellerUser,

          totalUsers: totalDirectUser + totalResellerUser,
        };
      }),
    );

    return res.status(200).json({
      success: true,
      total: result.length,
      data: result,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ===============================================
// GET ALL USERS
// ===============================================

const getAllUsers = async (req, res) => {
  try {
    const users = await User.find({
      role: "user",
    })
      .select(
        "name email phone ownerId paymentStatus moduleExpiredAt createdAt",
      )
      .populate("ownerId", "name role email");

    return res.status(200).json({
      success: true,
      total: users.length,
      data: users,
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ===============================================
// DASHBOARD ADMIN
// ===============================================

const getAdminStats = async (req, res) => {
  try {
    // Total reseller milik admin
    const totalResellers = await User.countDocuments({
      role: "reseller",
      ownerId: req.user._id,
    });

    // User langsung milik admin
    const totalDirectUsers = await User.countDocuments({
      role: "user",
      ownerId: req.user._id,
    });

    // Ambil seluruh reseller
    const resellerIds = await User.find({
      role: "reseller",
      ownerId: req.user._id,
    }).select("_id");

    const ids = resellerIds.map((item) => item._id);

    // User milik reseller
    const totalResellerUsers = await User.countDocuments({
      role: "user",
      ownerId: {
        $in: ids,
      },
    });

    // Total user admin + user reseller
    const totalUsers = totalDirectUsers + totalResellerUsers;

    // User aktif
    const activeUsers = await User.countDocuments({
      role: "user",
      paymentStatus: "active",
      $or: [
        {
          ownerId: req.user._id,
        },
        {
          ownerId: {
            $in: ids,
          },
        },
      ],
    });

    // User expired
    const expiredUsers = await User.countDocuments({
      role: "user",
      paymentStatus: "expired",
      $or: [
        {
          ownerId: req.user._id,
        },
        {
          ownerId: {
            $in: ids,
          },
        },
      ],
    });

    // User pending
    const pendingUsers = await User.countDocuments({
      role: "user",
      paymentStatus: "pending",
      $or: [
        {
          ownerId: req.user._id,
        },
        {
          ownerId: {
            $in: ids,
          },
        },
      ],
    });

    // Total transaksi admin
    const totalTransactions = await Transaction.countDocuments({
      actorId: req.user._id,
    });

    // Pending transaksi
    const pendingTransactions = await Transaction.countDocuments({
      actorId: req.user._id,
      status: "pending",
    });

    // Approved transaksi
    const approvedTransactions = await Transaction.countDocuments({
      actorId: req.user._id,
      status: "approved",
    });

    // Rejected transaksi
    const rejectedTransactions = await Transaction.countDocuments({
      actorId: req.user._id,
      status: "rejected",
    });

    // Revenue
    const revenueResult = await Transaction.aggregate([
      {
        $match: {
          actorId: req.user._id,
          status: "approved",
        },
      },
      {
        $group: {
          _id: null,
          totalRevenue: {
            $sum: "$amount",
          },
        },
      },
    ]);

    return res.status(200).json({
      success: true,
      data: {
        totalResellers,

        totalDirectUsers,

        totalResellerUsers,

        totalUsers,

        coinBalance: req.user.coinBalance,

        activeUsers,
        expiredUsers,
        pendingUsers,

        totalTransactions,

        pendingTransactions,
        approvedTransactions,
        rejectedTransactions,

        totalRevenue: revenueResult[0]?.totalRevenue || 0,
      },
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ===============================================
// DASHBOARD RESELLER
// ===============================================

const getResellerStats = async (req, res) => {
  try {
    // ==========================================
    // TOTAL USER MILIK RESELLER
    // ==========================================

    const totalUsers = await User.countDocuments({
      role: "user",
      ownerId: req.user._id,
    });

    // ==========================================
    // USER AKTIF
    // ==========================================

    const activeUsers = await User.countDocuments({
      role: "user",
      ownerId: req.user._id,
      paymentStatus: "active",
    });

    // ==========================================
    // USER EXPIRED
    // ==========================================

    const expiredUsers = await User.countDocuments({
      role: "user",
      ownerId: req.user._id,
      paymentStatus: "expired",
    });

    // ==========================================
    // USER PENDING
    // ==========================================

    const pendingUsers = await User.countDocuments({
      role: "user",
      ownerId: req.user._id,
      paymentStatus: "pending",
    });

    // ==========================================
    // COIN RESELLER
    // ==========================================

    const coinBalance = req.user.coinBalance || 0;

    // ==========================================
    // TOTAL TRANSAKSI RESELLER
    // ==========================================

    const totalTransactions = await Transaction.countDocuments({
      actorId: req.user._id,
    });

    // ==========================================
    // TRANSAKSI PENDING
    // ==========================================

    const pendingTransactions = await Transaction.countDocuments({
      actorId: req.user._id,
      status: "pending",
    });

    // ==========================================
    // TRANSAKSI APPROVED
    // ==========================================

    const approvedTransactions = await Transaction.countDocuments({
      actorId: req.user._id,
      status: "approved",
    });

    // ==========================================
    // RESPONSE
    // ==========================================

    return res.status(200).json({
      success: true,

      data: {
        totalUsers,

        coinBalance,

        activeUsers,
        expiredUsers,
        pendingUsers,

        totalTransactions,
        pendingTransactions,
        approvedTransactions,
      },
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// ===============================================
// EXPORT CONTROLLER
// ===============================================

module.exports = {
  getSuperAdminStats,
  getAllAdmins,
  getAllUsers,
  getAdminStats,
  getResellerStats,
};
