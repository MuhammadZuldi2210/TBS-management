const cron = require("node-cron");

const User = require("../models/User");
const { createNotification } = require("../services/notificationService");

let isRunning = false;

const startExpireJob = () => {
  // ============================================================
  // EXPIRE JOB
  // Berjalan setiap 1 jam pada menit 00
  // Contoh:
  // 10:00
  // 11:00
  // 12:00
  // 13:00
  // ============================================================

  cron.schedule("0 * * * *", async () => {
    // ============================================================
    // CEGAH JOB BERJALAN BERSAMAAN
    // ============================================================

    if (isRunning) {
      console.log("Expire job masih berjalan, execution dilewati.");
      return;
    }

    isRunning = true;

    const startedAt = Date.now();

    try {
      console.log("==========================================");
      console.log("Checking expired users...");

      const now = new Date();

      // ============================================================
      // CARI USER YANG SUDAH EXPIRED
      // ============================================================

      const users = await User.find({
        paymentStatus: "active",
        moduleExpiredAt: {
          $ne: null,
          $lte: now,
        },
      }).select("_id name email moduleExpiredAt");

      // ============================================================
      // TIDAK ADA USER EXPIRED
      // ============================================================

      if (users.length === 0) {
        console.log("No expired users found.");

        console.log(`Expire job selesai dalam ${Date.now() - startedAt}ms`);

        console.log("==========================================");

        return;
      }

      console.log(`Found ${users.length} expired user(s).`);

      // ============================================================
      // AMBIL ID USER
      // ============================================================

      const userIds = users.map((user) => user._id);

      // ============================================================
      // UPDATE STATUS SEKALIGUS
      // ============================================================

      const updateResult = await User.updateMany(
        {
          _id: { $in: userIds },
          paymentStatus: "active",
        },
        {
          $set: {
            paymentStatus: "expired",
          },
        },
      );

      console.log(`Updated ${updateResult.modifiedCount} user(s) to expired.`);

      // ============================================================
      // BUAT NOTIFIKASI
      // ============================================================

      let notificationSuccess = 0;
      let notificationFailed = 0;

      for (const user of users) {
        try {
          await createNotification(
            user._id,
            "Akun Anda Expired",
            "Silakan perpanjang langganan untuk mengakses aplikasi kembali",
            "expired",
          );

          notificationSuccess++;
        } catch (error) {
          notificationFailed++;

          console.log(
            `Notification failed for user ${user._id}:`,
            error.message,
          );
        }
      }

      // ============================================================
      // HASIL JOB
      // ============================================================

      console.log("------------------------------------------");
      console.log("Expired processed:", updateResult.modifiedCount);
      console.log("Notification success:", notificationSuccess);
      console.log("Notification failed:", notificationFailed);
      console.log(`Expire job selesai dalam ${Date.now() - startedAt}ms`);
      console.log("==========================================");
    } catch (error) {
      console.error("Expire job error:", error);
    } finally {
      // ============================================================
      // LEPAS LOCK
      // ============================================================

      isRunning = false;
    }
  });

  // ============================================================
  // LOG SAAT CRON BERHASIL DIDAFTARKAN
  // ============================================================

  console.log("Expire job started.");
  console.log("Schedule: setiap 1 jam.");
};

module.exports = startExpireJob;
