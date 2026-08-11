// import flutter
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import dashboard
import '../../dashboard/admin_user/views/admin_user_dashboard.dart';

// import dashboard provider
import '../../dashboard/admin_user/viewmodels/dashboard_provider.dart';

// import transaction
import '../../transaction/views/transaction_page.dart';

// import transaction provider
import '../../transaction/viewmodels/transaction_provider.dart';

// import profile
import '../../profile/views/profile_page.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// Navigation Admin User
class AdminUserNavigation extends StatefulWidget {
  const AdminUserNavigation({super.key});

  @override
  State<AdminUserNavigation> createState() => _AdminUserNavigationState();
}

class _AdminUserNavigationState extends State<AdminUserNavigation> {
  // ===============================
  // CURRENT PAGE
  // ===============================

  int currentIndex = 0;

  // ===============================
  // PAGES
  // ===============================

  final List<Widget> pages = const [
    AdminUserDashboard(),
    TransactionPage(),
    ProfilePage(),
  ];

  // ===============================
  // MENU
  // ===============================

  final List<Map<String, dynamic>> menus = [
    {"title": "Dashboard", "icon": Icons.dashboard_rounded},
    {"title": "Transaksi", "icon": Icons.receipt_long_rounded},
    {"title": "Profile", "icon": Icons.person_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ===============================
      // BODY
      // ===============================
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),

        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },

        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: pages[currentIndex],
        ),
      ),

      // ===============================
      // BOTTOM NAVIGATION
      // ===============================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

            decoration: BoxDecoration(
              color: AuthTheme.cardBackground,

              borderRadius: BorderRadius.circular(24),

              border: Border.all(color: AuthTheme.border.withOpacity(.7)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Row(
              children: List.generate(menus.length, (index) {
                final bool active = currentIndex == index;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,

                    // ===============================
                    // TAP MENU
                    // ===============================
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });

                      // ===============================
                      // REFRESH DASHBOARD
                      // ===============================

                      if (index == 0) {
                        context
                            .read<AdminDashboardProvider>()
                            .getDashboardStats();
                      }

                      // ===============================
                      // REFRESH TRANSAKSI
                      // ===============================

                      if (index == 1) {
                        context.read<TransactionProvider>().getTransactions();
                      }
                    },

                    // ===============================
                    // MENU ITEM
                    // ===============================
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),

                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),

                      decoration: BoxDecoration(
                        // ===============================
                        // ACTIVE GRADIENT
                        // ===============================
                        gradient: active ? AuthTheme.buttonGradient : null,

                        color: active ? null : Colors.transparent,

                        borderRadius: BorderRadius.circular(18),

                        // ===============================
                        // ACTIVE SHADOW
                        // ===============================
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: AuthTheme.blueGlow.withOpacity(.25),

                                  blurRadius: 10,

                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          // ===============================
                          // ICON
                          // ===============================
                          AnimatedScale(
                            scale: active ? 1.12 : 1.0,

                            duration: const Duration(milliseconds: 250),

                            child: Icon(
                              menus[index]["icon"],

                              size: 22,

                              color: active ? Colors.white : Colors.white54,
                            ),
                          ),

                          const SizedBox(height: 3),

                          // ===============================
                          // TITLE
                          // ===============================
                          Text(
                            menus[index]["title"],

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 10,

                              color: active ? Colors.white : Colors.white54,

                              fontWeight: active
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
