// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth provider
import '../../../auth/viewmodels/auth_provider.dart';

// import dashboard provider reseller
import '../viewmodels/dashboard_provider.dart';

// import auth theme
import '../../../../core/theme/auth_theme.dart';

// import add user page
import '../../../user_management/views/add_user_page.dart';

// import my user page
import '../../../user_management/views/my_user_page.dart';

// import notification provider
import '../../../notification/viewmodels/notification_provider.dart';

// import notification page
import '../../../notification/views/notification_page.dart';

// import request coin dialog
import '../../../coin/views/request_coin_dialog.dart';

// import widgets dashboard
import '../../../../core/widgets/dashboard/dashboard_section_title.dart';
import '../../../../core/widgets/dashboard/dashboard_stat_card.dart';
import '../../../../core/widgets/dashboard/welcome_card.dart';
import '../../../../core/widgets/dashboard/dashboard_menu_card.dart';

// Dashboard Reseller
class ResellerDashboard extends StatefulWidget {
  const ResellerDashboard({super.key});

  @override
  State<ResellerDashboard> createState() => _ResellerDashboardState();
}

class _ResellerDashboardState extends State<ResellerDashboard> {
  @override
  void initState() {
    super.initState();

    // ==========================================
    // LOAD DASHBOARD
    // ==========================================

    Future.microtask(() async {
      await context.read<AuthProvider>().refreshProfile();

      await context.read<ResellerDashboardProvider>().getDashboardStats();

      await context.read<NotificationProvider>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // PROVIDER
    // ==========================================

    final auth = Provider.of<AuthProvider>(context);

    final dashboard = Provider.of<ResellerDashboardProvider>(context);

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ==========================================
      // APP BAR
      // ==========================================
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset("assets/logos/TBS.png", fit: BoxFit.contain),
        ),

        centerTitle: true,

        title: const Text(
          "Dashboard",
          style: TextStyle(color: AuthTheme.title, fontWeight: FontWeight.bold),
        ),

        actions: [
          // ==========================================
          // NOTIFICATION
          // ==========================================
          Consumer<NotificationProvider>(
            builder: (context, notification, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: AuthTheme.title,
                      size: 28,
                    ),

                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationPage(),
                        ),
                      );

                      if (context.mounted) {
                        await context
                            .read<NotificationProvider>()
                            .getNotifications();
                      }
                    },
                  ),

                  // Badge unread
                  if (notification.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,

                      child: Container(
                        padding: const EdgeInsets.all(4),

                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),

                        child: Text(
                          notification.unreadCount.toString(),

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // ==========================================
          // LOGOUT
          // ==========================================
          Padding(
            padding: const EdgeInsets.only(right: 10),

            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.redAccent.withOpacity(.15)),
              ),

              child: IconButton(
                tooltip: "Logout",

                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 21,
                ),

                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,

                    builder: (dialogContext) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,

                        child: Container(
                          padding: const EdgeInsets.all(24),

                          decoration: BoxDecoration(
                            color: AuthTheme.cardBackground,
                            borderRadius: BorderRadius.circular(28),

                            border: Border.all(
                              color: Colors.white.withOpacity(.08),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.35),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              // ==================================
                              // ICON LOGOUT
                              // ==================================
                              Container(
                                width: 76,
                                height: 76,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  color: Colors.redAccent.withOpacity(.10),

                                  border: Border.all(
                                    color: Colors.redAccent.withOpacity(.25),
                                  ),
                                ),

                                child: Container(
                                  margin: const EdgeInsets.all(8),

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,

                                    color: Colors.redAccent.withOpacity(.08),
                                  ),

                                  child: const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.redAccent,
                                    size: 32,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // ==================================
                              // TITLE
                              // ==================================
                              const Text(
                                "Keluar dari Akun?",
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: AuthTheme.title,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // ==================================
                              // DESCRIPTION
                              // ==================================
                              const Text(
                                "Anda akan keluar dari sesi saat ini.\n"
                                "Pastikan semua aktivitas sudah selesai.",

                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: AuthTheme.subtitle,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 26),

                              // ==================================
                              // BUTTON
                              // ==================================
                              Row(
                                children: [
                                  // ==============================
                                  // BATAL
                                  // ==============================
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext, false);
                                      },

                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),

                                        side: BorderSide(
                                          color: Colors.white.withOpacity(.12),
                                        ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),

                                      child: const Text(
                                        "Batal",

                                        style: TextStyle(
                                          color: AuthTheme.subtitle,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // ==============================
                                  // LOGOUT
                                  // ==============================
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext, true);
                                      },

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        elevation: 0,

                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),

                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          Icon(Icons.logout_rounded, size: 18),

                                          SizedBox(width: 7),

                                          Text(
                                            "Logout",

                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  // ==========================================
                  // LOGOUT PROCESS
                  // ==========================================
                  if (confirm == true) {
                    await auth.logout();

                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, "/login");
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),

      // ==========================================
      // BODY
      // ==========================================
      body: dashboard.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboard.errorMessage != null
          ? Center(
              child: Text(
                dashboard.errorMessage!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ==========================================
                    // WELCOME CARD
                    // ==========================================
                    WelcomeCard(
                      name: auth.name ?? "Reseller",

                      role: auth.role ?? "reseller",

                      coinBalance: auth.coinBalance,

                      // ==========================================
                      // REQUEST COIN
                      // ==========================================
                      onTopupCoin: () {
                        // Pastikan reseller memiliki owner
                        if (auth.ownerId == null || auth.ownerId!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Admin pemilik reseller tidak ditemukan",
                              ),
                            ),
                          );

                          return;
                        }

                        // Buka dialog request coin
                        showDialog(
                          context: context,

                          builder: (_) {
                            return RequestCoinDialog(requestTo: auth.ownerId!);
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // STATISTIK
                    // ==========================================
                    const DashboardSectionTitle(
                      title: "Statistik",
                      icon: Icons.bar_chart_rounded,
                    ),

                    const SizedBox(height: 20),

                    GridView.builder(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            mainAxisExtent: 160,
                          ),

                      itemCount: 4,

                      itemBuilder: (context, index) {
                        final cards = [
                          DashboardStatCard(
                            title: "User Saya",

                            value: dashboard.totalUsers.toString(),

                            icon: Icons.people_alt_rounded,

                            color: AuthTheme.purpleGlow,
                          ),

                          DashboardStatCard(
                            title: "User Aktif",

                            value: dashboard.activeUsers.toString(),

                            icon: Icons.check_circle_rounded,

                            color: Colors.green,
                          ),

                          DashboardStatCard(
                            title: "User Expired",

                            value: dashboard.expiredUsers.toString(),

                            icon: Icons.access_time_filled_rounded,

                            color: Colors.redAccent,
                          ),

                          DashboardStatCard(
                            title: "Transaksi",

                            value: dashboard.totalTransactions.toString(),

                            icon: Icons.receipt_long_rounded,

                            color: Colors.blue,
                          ),
                        ];

                        return cards[index];
                      },
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // QUICK ACTION
                    // ==========================================
                    const DashboardSectionTitle(
                      title: "Quick Action",
                      icon: Icons.flash_on_rounded,
                    ),

                    const SizedBox(height: 20),

                    GridView.builder(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            mainAxisExtent: 150,
                          ),

                      itemCount: 1,

                      itemBuilder: (context, index) {
                        return DashboardMenuCard(
                          title: "Add User",

                          icon: Icons.person_add_alt_1_rounded,

                          color: AuthTheme.purpleGlow,

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const AddUserPage(),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // MANAGEMENT
                    // ==========================================
                    const DashboardSectionTitle(
                      title: "Management",
                      icon: Icons.folder_copy_rounded,
                    ),

                    const SizedBox(height: 20),

                    GridView.builder(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            mainAxisExtent: 150,
                          ),

                      itemCount: 1,

                      itemBuilder: (context, index) {
                        return DashboardMenuCard(
                          title: "User Saya",

                          icon: Icons.people_alt_rounded,

                          color: AuthTheme.purpleGlow,

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const MyUserPage(),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
