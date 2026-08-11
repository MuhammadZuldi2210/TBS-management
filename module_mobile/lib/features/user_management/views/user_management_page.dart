// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import user provider
import '../viewmodels/user_management_provider.dart';

// import deatail user
import 'user_detail_page.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // controller pencarian
  final TextEditingController searchController = TextEditingController();

  // keyword pencarian
  String searchQuery = "";
  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  void initState() {
    super.initState();

    // mengambil daftar user
    Future.microtask(() {
      context.read<UserManagementProvider>().getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ambil provider
    final provider = context.watch<UserManagementProvider>();

    return Scaffold(
      // background
      backgroundColor: AuthTheme.background,

      // appbar
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AuthTheme.title),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 35),

            const SizedBox(width: 10),

            const Text(
              "Kelola User",
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
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // judul halaman
            const Text(
              "Daftar User",

              style: TextStyle(
                color: AuthTheme.title,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // search user
            TextField(
              controller: searchController,

              style: const TextStyle(color: AuthTheme.title),

              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },

              decoration: InputDecoration(
                hintText: "Cari user...",

                hintStyle: const TextStyle(color: AuthTheme.subtitle),

                prefixIcon: const Icon(Icons.search, color: AuthTheme.subtitle),

                filled: true,

                fillColor: AuthTheme.cardBackground,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // list user
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

                    // data kosong
                    if (provider.userList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada data user",

                          style: TextStyle(color: AuthTheme.subtitle),
                        ),
                      );
                    }

                    // list user
                    // filter user berdasarkan pencarian
                    final filteredUsers = provider.userList.where((user) {
                      final name = user["name"]?.toString().toLowerCase() ?? "";
                      final email =
                          user["email"]?.toString().toLowerCase() ?? "";

                      return name.contains(searchQuery) ||
                          email.contains(searchQuery);
                    }).toList();

                    // list user
                    return ListView.builder(
                      padding: const EdgeInsets.all(15),

                      itemCount: filteredUsers.length,

                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];

                        return Card(
                          color: AuthTheme.background,

                          elevation: 0,

                          margin: const EdgeInsets.only(bottom: 15),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),

                            side: const BorderSide(color: AuthTheme.border),
                          ),

                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => UserDetailPage(user: user),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: AuthTheme.blueGlow.withValues(
                                alpha: 0.15,
                              ),

                              child: const Icon(
                                Icons.person,
                                color: AuthTheme.blueGlow,
                              ),
                            ),

                            title: Text(
                              user["name"] ?? "-",

                              style: const TextStyle(
                                color: AuthTheme.title,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      size: 15,
                                      color: AuthTheme.blueGlow,
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        user["email"] ?? "-",

                                        style: const TextStyle(
                                          color: AuthTheme.subtitle,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                Row(
                                  children: [
                                    Icon(
                                      user["paymentStatus"] == "active"
                                          ? Icons.check_circle
                                          : user["paymentStatus"] == "pending"
                                          ? Icons.access_time
                                          : Icons.cancel,

                                      size: 15,

                                      color: user["paymentStatus"] == "active"
                                          ? Colors.green
                                          : user["paymentStatus"] == "pending"
                                          ? Colors.orange
                                          : Colors.red,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
                                      "Status: ${user["paymentStatus"] ?? "-"}",

                                      style: const TextStyle(
                                        color: AuthTheme.subtitle,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            trailing: const Icon(
                              Icons.arrow_forward_ios,

                              size: 16,

                              color: AuthTheme.subtitle,
                            ),
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
