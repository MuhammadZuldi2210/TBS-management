// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth provider
import '../../../auth/viewmodels/auth_provider.dart';

// import dashboard provider
import '../viewmodels/dashboard_provider.dart';

// import auth theme
import '../../../../core/theme/auth_theme.dart';

// import add reseller page
import '../../../reseller_management/views/add_reseller_page.dart';

// Import add user page
import '../../../user_management/views/add_user_page.dart';

// Import my reseller
import '../../../reseller_management/views/my_reseller_page.dart';

// Import my user
import '../../../user_management/views/my_user_page.dart';

// import widgets dashboard
import '../../../../core/widgets/dashboard/dashboard_section_title.dart';
import '../../../../core/widgets/dashboard/dashboard_stat_card.dart';
import '../../../../core/widgets/dashboard/welcome_card.dart';
import '../../../../core/widgets/dashboard/dashboard_menu_card.dart';
import '../../../notification/viewmodels/notification_provider.dart';
import '../../../notification/views/notification_page.dart';
import '../../../coin/views/request_coin_dialog.dart';

// halaman dashboard super admin
class AdminUserDashboard extends StatefulWidget {
  const AdminUserDashboard({super.key});

  @override
  State<AdminUserDashboard> createState() => _AdminUserDashboardState();
}

// state dashboard super admin
class _AdminUserDashboardState extends State<AdminUserDashboard> {
  @override
  void initState() {
    super.initState();

    // mengambil statistik saat halaman dibuka
    Future.microtask(() async {
      await context.read<AuthProvider>().refreshProfile();

      await context.read<AdminDashboardProvider>().getDashboardStats();

      await context.read<NotificationProvider>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ambil auth provider
    final auth = Provider.of<AuthProvider>(context);

    // ambil dashboard provider
    final dashboard = Provider.of<AdminDashboardProvider>(context);

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // appbar
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
          // ==========================
          // NOTIFICATION
          // ==========================
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

                  // badge unread
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

          // ==========================
          // LOGOUT
          // ==========================
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
                              // LOGOUT ICON
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
                                  // BATAL
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

                                  // LOGOUT
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

      // body
      body: dashboard.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboard.errorMessage != null
          ? Center(child: Text(dashboard.errorMessage!))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // Welocme card
                    WelcomeCard(
                      name: auth.name ?? "Admin",
                      role: auth.role ?? "Admin User",
                      coinBalance: auth.coinBalance,

                      onTopupCoin: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return RequestCoinDialog(
                              requestTo: "6a44d1e882197472dc0a6304",
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // section statistik
                    const DashboardSectionTitle(
                      title: "Statistik",
                      icon: Icons.bar_chart_rounded,
                    ),

                    const SizedBox(height: 20),

                    // grid statistik
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
                            title: "Reseller",
                            value: dashboard.totalResellers.toString(),
                            icon: Icons.store,
                            color: Colors.orange,
                          ),

                          DashboardStatCard(
                            title: "User",
                            value: dashboard.totalUsers.toString(),
                            icon: Icons.people,
                            color: AuthTheme.purpleGlow,
                          ),

                          DashboardStatCard(
                            title: "User Aktif",
                            value: dashboard.activeUsers.toString(),
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),

                          DashboardStatCard(
                            title: "Transaksi",
                            value: dashboard.totalTransactions.toString(),
                            icon: Icons.receipt_long,
                            color: Colors.blue,
                          ),
                        ];

                        return cards[index];
                      },
                    ),

                    const SizedBox(height: 30),

                    // section menu
                    const DashboardSectionTitle(
                      title: "Quick Action",
                      icon: Icons.flash_on,
                    ),

                    const SizedBox(height: 30),

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

                      itemCount: 2,

                      itemBuilder: (context, index) {
                        final menus = [
                          {
                            "title": "Add Reseller",
                            "icon": Icons.store,
                            "color": Colors.orange,
                          },
                          {
                            "title": "Add User",
                            "icon": Icons.group_add,
                            "color": AuthTheme.purpleGlow,
                          },
                        ];

                        return DashboardMenuCard(
                          title: menus[index]["title"] as String,
                          icon: menus[index]["icon"] as IconData,
                          color: menus[index]["color"] as Color,

                          onTap: () async {
                            // Add Reseller
                            if (index == 0) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddResellerPage(),
                                ),
                              );

                              if (mounted) {
                                await context
                                    .read<AdminDashboardProvider>()
                                    .getDashboardStats();
                              }
                            }

                            // Add User
                            if (index == 1) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddUserPage(),
                                ),
                              );

                              if (mounted) {
                                await context
                                    .read<AdminDashboardProvider>()
                                    .getDashboardStats();
                              }
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    const DashboardSectionTitle(
                      title: "Management",
                      icon: Icons.folder_copy,
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

                      itemCount: 2,

                      itemBuilder: (context, index) {
                        final managementMenus = [
                          {
                            "title": "Reseller Saya",
                            "icon": Icons.store,
                            "color": Colors.orange,
                          },
                          {
                            "title": "User Saya",
                            "icon": Icons.people,
                            "color": AuthTheme.purpleGlow,
                          },
                        ];

                        return DashboardMenuCard(
                          title: managementMenus[index]["title"] as String,
                          icon: managementMenus[index]["icon"] as IconData,
                          color: managementMenus[index]["color"] as Color,

                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyResellerPage(),
                                ),
                              );
                            }

                            if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyUserPage(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
