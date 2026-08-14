// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import admin provider
import '../viewmodels/admin_provider.dart';

// import add admin page
import 'add_admin_page.dart';

// import admin detail page
import 'admin_detail_page.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({super.key});

  @override
  State<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  // controller search
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // mengambil daftar admin
    Future.microtask(() {
      context.read<AdminProvider>().getAdmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    // mengambil provider
    final provider = context.watch<AdminProvider>();

    return Scaffold(
      // background
      backgroundColor: AuthTheme.background,

      // appbar
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        // tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 30),

            const SizedBox(width: 10),

            const Text(
              "Kelola Admin",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // TOMBOL TAMBAH ADMIN
            // ==================================================
            SizedBox(
              width: double.infinity,

              child: Container(
                decoration: BoxDecoration(
                  gradient: AuthTheme.buttonGradient,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: AuthTheme.blueGlow.withValues(alpha: 0.15),

                      blurRadius: 15,

                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,

                    shadowColor: Colors.transparent,

                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddAdminPage()),
                    );
                  },

                  icon: const Icon(Icons.person_add_alt_1, color: Colors.white),

                  label: const Text(
                    "Tambah Admin",

                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // DAFTAR ADMIN
            // ==================================================
            Expanded(
              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: AuthTheme.cardBackground,

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(color: AuthTheme.border),

                  boxShadow: [
                    BoxShadow(
                      color: AuthTheme.blueGlow.withValues(alpha: 0.15),

                      blurRadius: 18,
                    ),
                  ],
                ),

                child: Builder(
                  builder: (_) {
                    // loading
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // belum ada data
                    if (provider.adminList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.admin_panel_settings_outlined,

                              size: 60,

                              color: AuthTheme.subtitle,
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Belum ada data admin",

                              style: TextStyle(
                                color: AuthTheme.title,

                                fontSize: 16,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Silahkan tambahkan admin baru",

                              style: TextStyle(
                                color: AuthTheme.subtitle,

                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // ==================================================
                    // LIST ADMIN
                    // ==================================================
                    return ListView.builder(
                      padding: const EdgeInsets.all(15),

                      itemCount: provider.adminList.length,

                      itemBuilder: (context, index) {
                        final admin = provider.adminList[index];

                        final String name = admin["name"]?.toString() ?? "-";

                        final String email = admin["email"]?.toString() ?? "-";

                        final String initial = name.isNotEmpty && name != "-"
                            ? name[0].toUpperCase()
                            : "A";

                        final bool isSuspended =
                            admin["accountStatus"] == "suspended";

                        final bool isActive = admin["isActive"] == true;

                        final Color statusColor = isSuspended
                            ? Colors.orange
                            : isActive
                            ? Colors.green
                            : Colors.red;

                        final String statusText = isSuspended
                            ? "Suspend"
                            : isActive
                            ? "Aktif"
                            : "Tidak Aktif";

                        final int coinBalance =
                            int.tryParse(
                              admin["coinBalance"]?.toString() ?? "0",
                            ) ??
                            0;

                        final int totalReseller =
                            int.tryParse(
                              admin["totalReseller"]?.toString() ?? "0",
                            ) ??
                            0;

                        final int totalUser =
                            int.tryParse(
                              admin["totalUser"]?.toString() ?? "0",
                            ) ??
                            0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: AuthTheme.cardBackground,

                            borderRadius: BorderRadius.circular(22),

                            border: Border.all(color: AuthTheme.border),

                            boxShadow: [
                              BoxShadow(
                                color: AuthTheme.blueGlow.withValues(
                                  alpha: 0.15,
                                ),

                                blurRadius: 20,

                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // ==================================================
                              // PROFILE ADMIN
                              // ==================================================
                              Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,

                                    decoration: BoxDecoration(
                                      gradient: AuthTheme.buttonGradient,

                                      shape: BoxShape.circle,

                                      boxShadow: [
                                        BoxShadow(
                                          color: AuthTheme.blueGlow.withValues(
                                            alpha: 0.20,
                                          ),

                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),

                                    child: Center(
                                      child: Text(
                                        initial,

                                        style: const TextStyle(
                                          color: Colors.white,

                                          fontSize: 22,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          name,

                                          maxLines: 1,

                                          overflow: TextOverflow.ellipsis,

                                          style: const TextStyle(
                                            color: AuthTheme.title,

                                            fontSize: 18,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,

                                              size: 14,

                                              color: AuthTheme.subtitle,
                                            ),

                                            const SizedBox(width: 5),

                                            Expanded(
                                              child: Text(
                                                email,

                                                maxLines: 1,

                                                overflow: TextOverflow.ellipsis,

                                                style: const TextStyle(
                                                  color: AuthTheme.subtitle,

                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 17),

                              // ==================================================
                              // STATUS
                              // ==================================================
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),

                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.10),

                                  borderRadius: BorderRadius.circular(20),

                                  border: Border.all(
                                    color: statusColor.withValues(alpha: 0.20),
                                  ),
                                ),

                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Icon(
                                      isSuspended
                                          ? Icons.block_outlined
                                          : isActive
                                          ? Icons.check_circle_outline
                                          : Icons.cancel_outlined,

                                      size: 15,

                                      color: statusColor,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
                                      statusText,

                                      style: TextStyle(
                                        color: statusColor,

                                        fontWeight: FontWeight.bold,

                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              // ==================================================
                              // STATISTIK ADMIN
                              // ==================================================
                              Row(
                                children: [
                                  // COIN
                                  Expanded(
                                    child: _statCard(
                                      icon: Icons.monetization_on_outlined,

                                      iconColor: Colors.amber,

                                      title: "Coin",

                                      value: "$coinBalance",
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // RESELLER
                                  Expanded(
                                    child: _statCard(
                                      icon: Icons.storefront_outlined,

                                      iconColor: AuthTheme.blueGlow,

                                      title: "Reseller",

                                      value: "$totalReseller",
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // USER
                                  Expanded(
                                    child: _statCard(
                                      icon: Icons.people_outline,

                                      iconColor: Colors.purpleAccent,

                                      title: "User",

                                      value: "$totalUser",
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // ==================================================
                              // BUTTON DETAIL
                              // ==================================================
                              Container(
                                width: double.infinity,

                                decoration: BoxDecoration(
                                  gradient: AuthTheme.buttonGradient,

                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,

                                    shadowColor: Colors.transparent,

                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),

                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AdminDetailPage(admin: admin),
                                      ),
                                    );

                                    if (result == true) {
                                      await provider.getAdmins();
                                    }
                                  },

                                  icon: const Icon(
                                    Icons.visibility_outlined,

                                    color: Colors.white,
                                  ),

                                  label: const Text(
                                    "Detail",

                                    style: TextStyle(
                                      color: Colors.white,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // STAT CARD
  // ==========================================================
  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: AuthTheme.border.withValues(alpha: 0.75)),
      ),

      child: Column(
        children: [
          // icon
          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: iconColor, size: 19),
          ),

          const SizedBox(height: 8),

          // angka
          Text(
            value,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              color: AuthTheme.title,

              fontSize: 17,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 2),

          // label
          Text(
            title,

            style: const TextStyle(
              color: AuthTheme.subtitle,

              fontSize: 10,

              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
