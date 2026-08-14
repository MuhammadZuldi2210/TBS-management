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

// import reseller detail page
import 'reseller_detail_page.dart';

// ==========================================================
// HALAMAN RESELLER SAYA
// ==========================================================

class MyResellerPage extends StatefulWidget {
  const MyResellerPage({super.key});

  @override
  State<MyResellerPage> createState() => _MyResellerPageState();
}

class _MyResellerPageState extends State<MyResellerPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<ResellerProvider>().getMyResellers();
    });
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

        leading: Padding(
          padding: const EdgeInsets.only(left: 8),

          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        titleSpacing: 4,

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 34),

            const SizedBox(width: 10),

            const Text(
              "Reseller Saya",

              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),

        child: Column(
          children: [
            // ==================================================
            // TOMBOL TAMBAH RESELLER
            // ==================================================
            _buildAddButton(context, provider),

            const SizedBox(height: 24),

            // ==================================================
            // DAFTAR RESELLER
            // ==================================================
            Expanded(
              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: AuthTheme.cardBackground,

                  borderRadius: BorderRadius.circular(24),

                  border: Border.all(color: AuthTheme.border),

                  boxShadow: [
                    BoxShadow(
                      color: AuthTheme.blueGlow.withValues(alpha: .10),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Builder(
                  builder: (_) {
                    // ==================================================
                    // LOADING
                    // ==================================================

                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ==================================================
                    // KOSONG
                    // ==================================================

                    if (provider.resellerList.isEmpty) {
                      return _buildEmptyState();
                    }

                    // ==================================================
                    // LIST RESELLER
                    // ==================================================

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),

                      padding: const EdgeInsets.all(15),

                      itemCount: provider.resellerList.length,

                      itemBuilder: (context, index) {
                        final reseller = provider.resellerList[index];

                        return _buildResellerCard(context, provider, reseller);
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
  // TOMBOL TAMBAH RESELLER
  // ==========================================================

  Widget _buildAddButton(BuildContext context, ResellerProvider provider) {
    return SizedBox(
      width: double.infinity,

      child: Container(
        decoration: BoxDecoration(
          gradient: AuthTheme.buttonGradient,

          borderRadius: BorderRadius.circular(17),

          boxShadow: [
            BoxShadow(
              color: AuthTheme.blueGlow.withValues(alpha: .18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,

            shadowColor: Colors.transparent,

            padding: const EdgeInsets.symmetric(vertical: 15),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),

          onPressed: () async {
            final result = await Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const AddResellerPage()),
            );

            if (result == true && mounted) {
              provider.getMyResellers();
            }
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: const [
              Icon(Icons.store_rounded, color: Colors.white, size: 20),

              SizedBox(width: 9),

              Text(
                "Tambah Reseller",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 78,
              height: 78,

              decoration: BoxDecoration(
                color: AuthTheme.blueGlow.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(24),

                border: Border.all(
                  color: AuthTheme.blueGlow.withValues(alpha: .15),
                ),
              ),

              child: const Icon(
                Icons.store_outlined,
                color: AuthTheme.blueGlow,
                size: 40,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Belum Ada Reseller",

              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Silakan tambahkan reseller baru\nuntuk mulai mengelola reseller Anda.",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: AuthTheme.subtitle,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // RESELLER CARD
  // ==========================================================

  Widget _buildResellerCard(
    BuildContext context,
    ResellerProvider provider,
    Map<String, dynamic> reseller,
  ) {
    final String name = reseller["name"]?.toString() ?? "Reseller";

    final String email = reseller["email"]?.toString() ?? "-";

    final int coin =
        int.tryParse(reseller["coinBalance"]?.toString() ?? "0") ?? 0;

    final int totalUser =
        int.tryParse(reseller["totalUser"]?.toString() ?? "0") ?? 0;

    final bool isActive = reseller["isActive"] == true;

    final bool isSuspended = reseller["accountStatus"] == "suspended";

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

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AuthTheme.cardBackground,

        borderRadius: BorderRadius.circular(21),

        border: Border.all(color: AuthTheme.border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 12,
            offset: const Offset(0, 5),
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
              // ICON RESELLER
              Container(
                width: 62,
                height: 62,

                decoration: BoxDecoration(
                  gradient: AuthTheme.buttonGradient,

                  borderRadius: BorderRadius.circular(19),

                  boxShadow: [
                    BoxShadow(
                      color: AuthTheme.blueGlow.withValues(alpha: .22),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.store_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),

              const SizedBox(width: 14),

              // INFO RESELLER
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: AuthTheme.title,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: AuthTheme.blueGlow.withValues(alpha: .10),

                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(
                              color: AuthTheme.blueGlow.withValues(alpha: .20),
                            ),
                          ),

                          child: const Text(
                            "RESELLER",

                            style: TextStyle(
                              color: AuthTheme.blueGlow,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          color: AuthTheme.subtitle,
                          size: 14,
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            email,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: AuthTheme.subtitle,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,

                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          statusText,

                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==================================================
          // INFO COIN & USER
          // ==================================================
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  icon: Icons.monetization_on_rounded,
                  title: "Coin",
                  value: coin.toString(),
                  iconColor: Colors.amber,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildInfoBox(
                  icon: Icons.people_alt_rounded,
                  title: "User",
                  value: totalUser.toString(),
                  iconColor: AuthTheme.blueGlow,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==================================================
          // DETAIL BUTTON
          // ==================================================
          SizedBox(
            width: double.infinity,

            child: Container(
              decoration: BoxDecoration(
                gradient: AuthTheme.buttonGradient,

                borderRadius: BorderRadius.circular(13),
              ),

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,

                  shadowColor: Colors.transparent,

                  padding: const EdgeInsets.symmetric(vertical: 14),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),

                onPressed: () async {
                  await Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => ResellerDetailPage(reseller: reseller),
                    ),
                  );

                  if (mounted) {
                    provider.getMyResellers();
                  }
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: const [
                    Icon(
                      Icons.visibility_rounded,
                      color: Colors.white,
                      size: 18,
                    ),

                    SizedBox(width: 8),

                    Text(
                      "Detail Reseller",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFO BOX
  // ==========================================================

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),

      decoration: BoxDecoration(
        color: AuthTheme.inputFill,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: AuthTheme.border),
      ),

      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,

            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .10),

              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(icon, color: iconColor, size: 20),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: AuthTheme.subtitle,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: AuthTheme.title,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
