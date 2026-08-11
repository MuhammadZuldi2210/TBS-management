// import flutter material
import 'package:flutter/material.dart';
import 'package:module_mobile/features/admin_management/views/add_admin_page.dart';

// import provider
import 'package:provider/provider.dart';

import '../../../transaction/viewmodels/transaction_provider.dart';

// import auth provider
import '../../../auth/viewmodels/auth_provider.dart';

// import dashboard provider
import '../viewmodels/dashboard_provider.dart';

// import auth theme
import '../../../../core/theme/auth_theme.dart';

// import admin management page
import '../../../admin_management/views/admin_management_page.dart';

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
import '../../../reseller_management/views/reseller_management_page.dart';
import '../../../admin_management/views/admin_all_user_page.dart';
import '../../../notification/viewmodels/notification_provider.dart';
import '../../../notification/views/notification_page.dart';

// halaman dashboard super admin
class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

// state dashboard super admin
class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  @override
  void initState() {
    super.initState();

    // mengambil statistik saat halaman dibuka
    Future.microtask(() async {
      await context.read<DashboardProvider>().getStats();

      await context.read<NotificationProvider>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ambil auth provider
    final auth = Provider.of<AuthProvider>(context);

    // ambil dashboard provider
    final dashboard = Provider.of<DashboardProvider>(context);

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
                    // Logout auth
                    await auth.logout();

                    // Bersihkan state transaksi
                    if (context.mounted) {
                      context.read<TransactionProvider>().clearTransactions();

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // welcome card
              WelcomeCard(
                name: auth.name ?? "Super Admin",

                role: auth.role ?? "Super Admin",
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

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  crossAxisSpacing: 15,

                  mainAxisSpacing: 15,

                  mainAxisExtent: 160,
                ),

                itemCount: 4,

                itemBuilder: (context, index) {
                  // daftar statistik
                  final cards = [
                    DashboardStatCard(
                      title: "Admin",
                      value: dashboard.stats["totalAdmins"]?.toString() ?? "0",
                      icon: Icons.admin_panel_settings,
                      color: AuthTheme.blueGlow,
                    ),

                    DashboardStatCard(
                      title: "Reseller",
                      value:
                          dashboard.stats["totalResellers"]?.toString() ?? "0",
                      icon: Icons.store,
                      color: Colors.orange,
                    ),

                    DashboardStatCard(
                      title: "User",
                      value: dashboard.stats["totalUsers"]?.toString() ?? "0",
                      icon: Icons.people,
                      color: AuthTheme.purpleGlow,
                    ),

                    DashboardStatCard(
                      title: "Transaksi",
                      value:
                          dashboard.stats["totalTransactions"]?.toString() ??
                          "0",
                      icon: Icons.receipt_long,
                      color: Colors.green,
                    ),
                  ];

                  // tampilkan statistik
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

              // grid menu dashboard
              GridView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  crossAxisSpacing: 15,

                  mainAxisSpacing: 15,

                  mainAxisExtent: 150,
                ),

                itemCount: 3,

                itemBuilder: (context, index) {
                  // daftar menu
                  final menus = [
                    {
                      "title": "Add Admin",
                      "icon": Icons.person_add,
                      "color": AuthTheme.blueGlow,
                    },
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
                      // Add Admin
                      if (index == 0) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddAdminPage(),
                          ),
                        );

                        if (mounted) {
                          await context.read<DashboardProvider>().getStats();
                        }
                      }

                      // Add Reseller
                      if (index == 1) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddResellerPage(),
                          ),
                        );

                        if (mounted) {
                          await context.read<DashboardProvider>().getStats();
                        }
                      }

                      // Add User
                      if (index == 2) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddUserPage(),
                          ),
                        );

                        if (mounted) {
                          await context.read<DashboardProvider>().getStats();
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

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 150,
                ),

                itemCount: 5,

                itemBuilder: (context, index) {
                  final managementMenus = [
                    {
                      "title": "Kelola Admin",
                      "icon": Icons.admin_panel_settings,
                      "color": AuthTheme.blueGlow,
                    },
                    {
                      "title": "Kelola Reseller",
                      "icon": Icons.store,
                      "color": Colors.orange,
                    },
                    {
                      "title": "Kelola User",
                      "icon": Icons.people,
                      "color": AuthTheme.purpleGlow,
                    },

                    {
                      "title": "reseller saya",
                      "icon": Icons.person,
                      "color": Colors.green,
                    },

                    {
                      "title": "user saya",
                      "icon": Icons.person,
                      "color": Colors.green,
                    },
                  ];

                  return DashboardMenuCard(
                    title: managementMenus[index]["title"] as String,
                    icon: managementMenus[index]["icon"] as IconData,
                    color: managementMenus[index]["color"] as Color,

                    onTap: () {
                      // Kelola admin
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminManagementPage(),
                          ),
                        );
                      }

                      if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResellerManagementPage(),
                          ),
                        );
                      }

                      if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminAllUserPage(),
                          ),
                        );
                      }

                      // reseller saya
                      if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyResellerPage(),
                          ),
                        );
                      }

                      // user saya
                      if (index == 4) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MyUserPage()),
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
