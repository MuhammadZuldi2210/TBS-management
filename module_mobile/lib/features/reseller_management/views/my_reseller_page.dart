// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import reseller provider
import '../viewmodels/reseller_provider.dart';

// import add reseller page
import 'add_reseller_page.dart';

// Import reseller detail page
// import detail reseller
import 'reseller_detail_page.dart';

// halaman reseller saya
class MyResellerPage extends StatefulWidget {
  const MyResellerPage({super.key});

  @override
  State<MyResellerPage> createState() => _MyResellerPageState();
}

// state halaman
class _MyResellerPageState extends State<MyResellerPage> {
  @override
  void initState() {
    super.initState();

    // mengambil reseller milik super admin
    Future.microtask(() {
      context.read<ResellerProvider>().getMyResellers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // provider reseller
    final provider = context.watch<ResellerProvider>();

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
              "Reseller Saya",

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
            // tombol tambah reseller
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

                  onPressed: () async {
                    final result = await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const AddResellerPage(),
                      ),
                    );

                    if (result == true) {
                      provider.getMyResellers();
                    }
                  },

                  icon: const Icon(Icons.store, color: Colors.white),

                  label: const Text(
                    "Tambah Reseller",

                    style: TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // daftar reseller
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

                    // kosong
                    if (provider.resellerList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.store_outlined,

                              size: 60,

                              color: AuthTheme.subtitle,
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Belum ada reseller",

                              style: TextStyle(
                                color: AuthTheme.title,

                                fontSize: 16,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Silahkan tambahkan reseller baru",

                              style: TextStyle(color: AuthTheme.subtitle),
                            ),
                          ],
                        ),
                      );
                    }

                    // list reseller
                    return ListView.builder(
                      padding: const EdgeInsets.all(15),

                      itemCount: provider.resellerList.length,

                      itemBuilder: (context, index) {
                        final reseller = provider.resellerList[index];

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
                                        (reseller["name"] ?? "-")
                                            .substring(0, 1)
                                            .toUpperCase(),

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
                                          reseller["name"],

                                          style: const TextStyle(
                                            color: AuthTheme.title,

                                            fontSize: 18,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          reseller["email"],

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

                              Text(
                                "Coin : ${reseller["coinBalance"] ?? 0}",

                                style: const TextStyle(
                                  color: AuthTheme.title,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "User : ${reseller["totalUser"] ?? 0}",

                                style: const TextStyle(color: AuthTheme.title),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,

                                    size: 10,

                                    color: reseller["isActive"] == true
                                        ? Colors.green
                                        : Colors.red,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    reseller["accountStatus"] == "suspended"
                                        ? "Suspend"
                                        : reseller["isActive"] == true
                                        ? "Aktif"
                                        : "Tidak Aktif",

                                    style: TextStyle(
                                      color:
                                          reseller["accountStatus"] ==
                                              "suspended"
                                          ? Colors.orange
                                          : reseller["isActive"] == true
                                          ? Colors.green
                                          : Colors.red,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

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
                                    await Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (_) => ResellerDetailPage(
                                          reseller: reseller,
                                        ),
                                      ),
                                    );

                                    provider.getMyResellers();
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
