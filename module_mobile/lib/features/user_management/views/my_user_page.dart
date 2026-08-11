// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import user provider
import '../viewmodels/user_management_provider.dart';

// import add user page
import 'add_user_page.dart';

// import detail user page
import 'user_detail_page.dart';

// halaman user saya
class MyUserPage extends StatefulWidget {
  const MyUserPage({super.key});

  @override
  State<MyUserPage> createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<UserManagementProvider>().getMyUsers();
    });
  }

  Future<void> _refreshUsers() async {
    if (!mounted) return;

    await context.read<UserManagementProvider>().getMyUsers();
  }

  Future<void> _openAddUser() async {
    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddUserPage()),
    );

    if (!mounted) return;

    if (result == true) {
      await _refreshUsers();
    }
  }

  Future<void> _openUserDetail(Map<String, dynamic> user) async {
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailPage(user: user)),
    );

    if (!mounted) return;

    await _refreshUsers();
  }

  String _getInitial(String? name) {
    if (name == null || name.trim().isEmpty) {
      return "-";
    }

    return name.trim().substring(0, 1).toUpperCase();
  }

  String _getName(dynamic value) {
    if (value == null) {
      return "-";
    }

    final name = value.toString().trim();

    if (name.isEmpty) {
      return "-";
    }

    return name;
  }

  String _getStatusText(Map<String, dynamic> user) {
    if (user["accountStatus"] == "suspended") {
      return "Suspend";
    }

    if (user["isActive"] == true) {
      return "Aktif";
    }

    return "Tidak Aktif";
  }

  Color _getStatusColor(Map<String, dynamic> user) {
    if (user["accountStatus"] == "suspended") {
      return Colors.orange;
    }

    if (user["isActive"] == true) {
      return Colors.green;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserManagementProvider>();

    return Scaffold(
      backgroundColor: AuthTheme.background,

      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

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
              "User Saya",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // =========================================================
            // BUTTON TAMBAH USER
            // =========================================================
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

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  onPressed: _openAddUser,

                  icon: const Icon(Icons.person_add, color: Colors.white),

                  label: const Text(
                    "Tambah User",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =========================================================
            // DAFTAR USER
            // =========================================================
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
                  builder: (context) {
                    // =================================================
                    // LOADING
                    // =================================================
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // =================================================
                    // DATA KOSONG
                    // =================================================
                    if (provider.userList.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refreshUsers,

                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),

                          children: const [
                            SizedBox(height: 180),

                            Icon(
                              Icons.person_outline,
                              size: 60,
                              color: AuthTheme.subtitle,
                            ),

                            SizedBox(height: 15),

                            Center(
                              child: Text(
                                "Belum ada user",
                                style: TextStyle(
                                  color: AuthTheme.title,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            Center(
                              child: Text(
                                "Silahkan tambahkan user baru",
                                style: TextStyle(color: AuthTheme.subtitle),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // =================================================
                    // LIST USER
                    // =================================================
                    return RefreshIndicator(
                      onRefresh: _refreshUsers,

                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),

                        padding: const EdgeInsets.all(15),

                        itemCount: provider.userList.length,

                        itemBuilder: (context, index) {
                          final user = provider.userList[index];

                          final String name = _getName(user["name"]);

                          final String email = _getName(user["email"]);

                          final String phone = _getName(user["phone"]);

                          final String expiredAt = _getName(
                            user["moduleExpiredAt"],
                          );

                          final Color statusColor = _getStatusColor(user);

                          final String statusText = _getStatusText(user);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 18),

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: AuthTheme.cardBackground,

                              borderRadius: BorderRadius.circular(18),

                              border: Border.all(color: AuthTheme.border),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // =====================================
                                // USER HEADER
                                // =====================================
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,

                                      decoration: BoxDecoration(
                                        gradient: AuthTheme.buttonGradient,

                                        shape: BoxShape.circle,
                                      ),

                                      child: Center(
                                        child: Text(
                                          _getInitial(name),

                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
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

                                          const SizedBox(height: 4),

                                          Text(
                                            email,

                                            maxLines: 1,

                                            overflow: TextOverflow.ellipsis,

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

                                // =====================================
                                // PHONE
                                // =====================================
                                Text(
                                  "No HP : $phone",

                                  style: const TextStyle(
                                    color: AuthTheme.title,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // =====================================
                                // EXPIRED
                                // =====================================
                                Text(
                                  "Expired : $expiredAt",

                                  style: const TextStyle(
                                    color: AuthTheme.title,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // =====================================
                                // STATUS
                                // =====================================
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: statusColor,
                                    ),

                                    const SizedBox(width: 8),

                                    Text(
                                      statusText,

                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // =====================================
                                // DETAIL BUTTON
                                // =====================================
                                SizedBox(
                                  width: double.infinity,

                                  child: Container(
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),

                                      onPressed: () {
                                        _openUserDetail(user);
                                      },

                                      icon: const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                        size: 18,
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
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
