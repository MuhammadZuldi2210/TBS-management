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
            // tombol tambah admin
            SizedBox(
              width: double.infinity,

              child: Container(
                decoration: BoxDecoration(
                  gradient: AuthTheme.buttonGradient,
                  borderRadius: BorderRadius.circular(20),
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

            const SizedBox(height: 20),

            // daftar admin
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
                    // list admin
                    return ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: provider.adminList.length,
                      itemBuilder: (context, index) {
                        final admin = provider.adminList[index];

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
                              Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,

                                    decoration: BoxDecoration(
                                      gradient: AuthTheme.buttonGradient,
                                      shape: BoxShape.circle,
                                    ),

                                    child: Center(
                                      child: Text(
                                        admin["name"][0].toUpperCase(),

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
                                          admin["name"],
                                          style: const TextStyle(
                                            color: AuthTheme.title,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          admin["email"],
                                          style: const TextStyle(
                                            color: AuthTheme.subtitle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(
                                  color: admin["accountStatus"] == "suspended"
                                      ? Colors.orange.withValues(alpha: 0.15)
                                      : admin["isActive"] == true
                                      ? Colors.green.withValues(alpha: 0.15)
                                      : Colors.red.withValues(alpha: 0.15),

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 9,

                                      color:
                                          admin["accountStatus"] == "suspended"
                                          ? Colors.orange
                                          : admin["isActive"] == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
                                      admin["accountStatus"] == "suspended"
                                          ? "Suspend"
                                          : admin["isActive"] == true
                                          ? "Aktif"
                                          : "Tidak Aktif",

                                      style: TextStyle(
                                        color:
                                            admin["accountStatus"] ==
                                                "suspended"
                                            ? Colors.orange
                                            : admin["isActive"] == true
                                            ? Colors.green
                                            : Colors.red,

                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Coin : ${admin["coinBalance"]}",
                                style: const TextStyle(
                                  color: AuthTheme.title,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Reseller : ${admin["totalReseller"]}",
                                style: const TextStyle(color: AuthTheme.title),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "User : ${admin["totalUser"] ?? 0}",
                                style: const TextStyle(color: AuthTheme.title),
                              ),

                              const SizedBox(height: 20),

                              // BUTTON DETAIL
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
                                    Icons.visibility,
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
}
