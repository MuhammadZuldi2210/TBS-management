// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import reseller provider
import '../viewmodels/reseller_provider.dart';

// import detail reseller
import 'reseller_detail_page.dart';

// Halaman kelola semua reseller super admin
class ResellerManagementPage extends StatefulWidget {
  const ResellerManagementPage({super.key});

  @override
  State<ResellerManagementPage> createState() => _ResellerManagementPageState();
}

class _ResellerManagementPageState extends State<ResellerManagementPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ResellerProvider>().getAllResellers();
    });
  }

  // ==========================================================
  // REFRESH DATA RESELLER
  // ==========================================================

  Future<void> _refreshResellers() async {
    if (!mounted) return;

    await context.read<ResellerProvider>().getAllResellers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResellerProvider>();

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            if (!mounted) return;

            Navigator.pop(context);
          },
        ),

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 30),

            const SizedBox(width: 10),

            const Text(
              "Kelola Reseller",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: provider.isLoading && provider.resellerList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : provider.resellerList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada reseller",
                style: TextStyle(color: AuthTheme.title),
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshResellers,

              child: ListView.builder(
                padding: const EdgeInsets.all(20),

                itemCount: provider.resellerList.length,

                itemBuilder: (context, index) {
                  final reseller = provider.resellerList[index];

                  final bool isSuspended =
                      reseller["accountStatus"] == "suspended";

                  final bool isActive = reseller["isActive"] == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AuthTheme.cardBackground,

                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(color: AuthTheme.border),

                      boxShadow: [
                        BoxShadow(
                          color: AuthTheme.blueGlow.withValues(alpha: 0.12),
                          blurRadius: 15,
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // ==================================================
                        // HEADER
                        // ==================================================
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
                                  reseller["name"] != null &&
                                          reseller["name"].toString().isNotEmpty
                                      ? reseller["name"]
                                            .toString()[0]
                                            .toUpperCase()
                                      : "R",

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
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    reseller["name"] ?? "-",

                                    style: const TextStyle(
                                      color: AuthTheme.title,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    reseller["email"] ?? "-",

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

                        // ==================================================
                        // PEMILIK
                        // ==================================================
                        Text(
                          "Pemilik Admin : "
                          "${reseller["ownerId"] is Map ? reseller["ownerId"]["name"] : "-"}",

                          style: const TextStyle(
                            color: AuthTheme.title,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ==================================================
                        // USER + COIN
                        // ==================================================
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "User : "
                                "${reseller["totalUser"] ?? 0}",

                                style: const TextStyle(color: AuthTheme.title),
                              ),
                            ),

                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    "${reseller["coinBalance"] ?? 0} Coin",

                                    style: const TextStyle(
                                      color: AuthTheme.title,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ==================================================
                        // STATUS
                        // ==================================================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: isSuspended
                                ? Colors.orange.withValues(alpha: 0.12)
                                : isActive
                                ? Colors.green.withValues(alpha: 0.12)
                                : Colors.red.withValues(alpha: 0.12),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Icon(
                                Icons.circle,
                                size: 9,

                                color: isSuspended
                                    ? Colors.orange
                                    : isActive
                                    ? Colors.green
                                    : Colors.red,
                              ),

                              const SizedBox(width: 7),

                              Text(
                                isSuspended
                                    ? "Suspend"
                                    : isActive
                                    ? "Aktif"
                                    : "Tidak Aktif",

                                style: TextStyle(
                                  color: isSuspended
                                      ? Colors.orange
                                      : isActive
                                      ? Colors.green
                                      : Colors.red,

                                  fontWeight: FontWeight.bold,

                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // DETAIL
                        // ==================================================
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
                              ),

                              onPressed: () async {
                                await Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ResellerDetailPage(reseller: reseller),
                                  ),
                                );

                                // Jangan refresh kalau
                                // halaman sudah tidak ada.
                                if (!mounted) return;

                                // Ambil data terbaru setelah
                                // kembali dari detail.
                                await _refreshResellers();
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
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
