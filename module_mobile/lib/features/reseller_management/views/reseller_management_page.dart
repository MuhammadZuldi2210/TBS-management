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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storefront_outlined,
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
                    "Data reseller akan tampil di sini",
                    style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
                  ),
                ],
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

                  final String name = reseller["name"]?.toString() ?? "-";

                  final String email = reseller["email"]?.toString() ?? "-";

                  final String initial = name.isNotEmpty && name != "-"
                      ? name[0].toUpperCase()
                      : "R";

                  final int totalUser =
                      int.tryParse(reseller["totalUser"]?.toString() ?? "0") ??
                      0;

                  final int coinBalance =
                      int.tryParse(
                        reseller["coinBalance"]?.toString() ?? "0",
                      ) ??
                      0;

                  final String ownerName = reseller["ownerId"] is Map
                      ? reseller["ownerId"]["name"]?.toString() ?? "-"
                      : "-";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AuthTheme.cardBackground,

                      borderRadius: BorderRadius.circular(22),

                      border: Border.all(color: AuthTheme.border),

                      boxShadow: [
                        BoxShadow(
                          color: AuthTheme.blueGlow.withValues(alpha: 0.15),

                          blurRadius: 20,

                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // ==================================================
                        // HEADER RESELLER
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
                                crossAxisAlignment: CrossAxisAlignment.start,

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
                        // PEMILIK ADMIN
                        // ==================================================
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 11,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.035),

                            borderRadius: BorderRadius.circular(13),

                            border: Border.all(
                              color: AuthTheme.border.withValues(alpha: 0.75),
                            ),
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,

                                decoration: BoxDecoration(
                                  color: AuthTheme.blueGlow.withValues(
                                    alpha: 0.10,
                                  ),

                                  borderRadius: BorderRadius.circular(9),
                                ),

                                child: const Icon(
                                  Icons.admin_panel_settings_outlined,

                                  color: AuthTheme.blueGlow,

                                  size: 18,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    const Text(
                                      "Pemilik Admin",

                                      style: TextStyle(
                                        color: AuthTheme.subtitle,

                                        fontSize: 10,

                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      ownerName,

                                      maxLines: 1,

                                      overflow: TextOverflow.ellipsis,

                                      style: const TextStyle(
                                        color: AuthTheme.title,

                                        fontSize: 13,

                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ==================================================
                        // STATISTIK RESELLER
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

                        const SizedBox(height: 16),

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

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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

                                if (!mounted) return;

                                await _refreshResellers();
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
                        ),
                      ],
                    ),
                  );
                },
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
