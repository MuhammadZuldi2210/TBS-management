// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import intl
import 'package:intl/intl.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import transaction provider
import '../viewmodels/transaction_provider.dart';

// import dashboard admin provider
import '../../dashboard/admin_user/viewmodels/dashboard_provider.dart';

// import auth provider
import '../../auth/viewmodels/auth_provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TransactionProvider>().getTransactions(page: 1, limit: 10);
    });
  }

  // ==========================================
  // FILTER BUTTON
  // ==========================================

  Widget _filterButton(
    BuildContext context,
    String title,
    String? type,
    String? status,
  ) {
    final provider = context.watch<TransactionProvider>();

    final active =
        provider.selectedType == type && provider.selectedStatus == status;

    return GestureDetector(
      onTap: () {
        context.read<TransactionProvider>().getTransactions(
          type: type,
          status: status,
          page: 1,
          limit: provider.pageLimit,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: active ? AuthTheme.buttonGradient : null,
          color: active ? null : AuthTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? Colors.transparent : AuthTheme.border,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // PAGINATION BUTTON
  // ==========================================

  Widget _paginationButton({
    required String title,
    required VoidCallback? onPressed,
  }) {
    final enabled = onPressed != null;

    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? AuthTheme.cardBackground
              : AuthTheme.cardBackground.withOpacity(.4),
          foregroundColor: enabled ? Colors.white : Colors.white30,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: enabled ? AuthTheme.border : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ======================================
      // APP BAR
      // ======================================
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,
        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 35, width: 35),

            const SizedBox(width: 12),

            const Text(
              "Transaksi",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),

      // ======================================
      // BODY
      // ======================================
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // ==================================
            // FILTER
            // ==================================
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _filterButton(context, "Semua", null, null),

                _filterButton(context, "Modul", "module_extension", null),

                _filterButton(context, "Coin", "coin_purchase", null),

                _filterButton(context, "Pending", null, "pending"),

                _filterButton(context, "Approved", null, "approved"),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================
            // TRANSACTION LIST
            // ==================================
            Expanded(
              child: Builder(
                builder: (_) {
                  // Loading pertama
                  if (provider.isLoading && provider.transactionList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Empty
                  if (provider.transactionList.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada transaksi",
                        style: TextStyle(color: AuthTheme.subtitle),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // ==================================
                      // LIST
                      // ==================================
                      Expanded(
                        child: Stack(
                          children: [
                            ListView.builder(
                              itemCount: provider.transactionList.length,

                              itemBuilder: (context, index) {
                                final transaction =
                                    provider.transactionList[index];

                                // ==================================
                                // DATA TRANSACTION
                                // ==================================

                                final type = transaction["type"];

                                final actor = transaction["actorId"];

                                final user = transaction["userId"];

                                final status = transaction["status"];

                                final id = transaction["_id"];

                                final requestTo = transaction["requestTo"];

                                // ==================================
                                // REQUEST TO ID
                                // ==================================

                                final String? requestToId = requestTo is Map
                                    ? requestTo["_id"]?.toString()
                                    : requestTo?.toString();

                                // ==================================
                                // CEK REQUEST RECEIVER
                                // ==================================

                                final bool isRequestReceiver =
                                    requestToId != null &&
                                    requestToId == auth.userId?.toString();

                                // ==================================
                                // CEK BOLEH APPROVE
                                // ==================================

                                final bool canApprove =
                                    type == "coin_purchase" &&
                                    status == "pending" &&
                                    isRequestReceiver;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),

                                  padding: const EdgeInsets.all(18),

                                  decoration: BoxDecoration(
                                    color: AuthTheme.cardBackground,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AuthTheme.border),
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      // ==================================
                                      // HEADER
                                      // ==================================
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,

                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                type == "module_extension"
                                                    ? Icons.calendar_month
                                                    : type == "coin_topup"
                                                    ? Icons
                                                          .account_balance_wallet
                                                    : Icons.monetization_on,
                                                color: Colors.white,
                                                size: 22,
                                              ),

                                              const SizedBox(width: 10),

                                              Text(
                                                type == "module_extension"
                                                    ? "Extend Modul"
                                                    : type == "coin_topup"
                                                    ? "Topup Coin"
                                                    : "Request Coin",
                                                style: const TextStyle(
                                                  color: AuthTheme.title,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // STATUS
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),

                                            decoration: BoxDecoration(
                                              color: status == "approved"
                                                  ? Colors.green.withOpacity(
                                                      .15,
                                                    )
                                                  : Colors.orange.withOpacity(
                                                      .15,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),

                                            child: Text(
                                              status.toString().toUpperCase(),

                                              style: TextStyle(
                                                color: status == "approved"
                                                    ? Colors.green
                                                    : Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 15),

                                      // ==================================
                                      // ACTOR
                                      // ==================================
                                      Text(
                                        "Oleh: ${actor?["name"] ?? "-"}",
                                        style: const TextStyle(
                                          color: AuthTheme.subtitle,
                                        ),
                                      ),

                                      // ==================================
                                      // USER
                                      // ==================================
                                      if (user != null) ...[
                                        const SizedBox(height: 8),

                                        Text(
                                          "User: ${user["name"] ?? "-"}",
                                          style: const TextStyle(
                                            color: AuthTheme.subtitle,
                                          ),
                                        ),
                                      ],

                                      // ==================================
                                      // COIN PURCHASE
                                      // ==================================
                                      if (type == "coin_purchase") ...[
                                        const SizedBox(height: 12),

                                        Text(
                                          "Nominal: Rp ${NumberFormat("#,###").format(transaction["amount"] ?? 0)}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          "Coin: ${transaction["coinUsed"] ?? 0}",
                                          style: const TextStyle(
                                            color: AuthTheme.subtitle,
                                          ),
                                        ),
                                      ],

                                      // ==================================
                                      // MODULE EXTENSION
                                      // ==================================
                                      if (type == "module_extension") ...[
                                        const SizedBox(height: 12),

                                        Text(
                                          "Durasi: ${transaction["durationDays"] ?? 0} Hari",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],

                                      // ==================================
                                      // APPROVE BUTTON
                                      // ==================================
                                      if (canApprove) ...[
                                        const SizedBox(height: 15),

                                        SizedBox(
                                          width: double.infinity,

                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,

                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),

                                            onPressed: provider.isLoading
                                                ? null
                                                : () async {
                                                    final transactionProvider =
                                                        context
                                                            .read<
                                                              TransactionProvider
                                                            >();

                                                    final success =
                                                        await transactionProvider
                                                            .approveTransaction(
                                                              id,
                                                              auth,
                                                            );

                                                    if (!context.mounted) {
                                                      return;
                                                    }

                                                    if (success) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            "Request coin berhasil di-approve",
                                                          ),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );

                                                      // Refresh dashboard
                                                      await context
                                                          .read<
                                                            AdminDashboardProvider
                                                          >()
                                                          .getDashboardStats();

                                                      // Provider sudah
                                                      // refresh transaksi
                                                      // pada halaman aktif.
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            transactionProvider
                                                                    .errorMessage ??
                                                                "Gagal approve request coin",
                                                          ),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                        ),
                                                      );
                                                    }
                                                  },

                                            child: const Text(
                                              "Approve",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),

                            // ==================================
                            // LOADING SAAT PINDAH HALAMAN
                            // ==================================
                            if (provider.isLoading)
                              Positioned.fill(
                                child: Container(
                                  color: AuthTheme.background.withOpacity(.35),

                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ==================================
                      // PAGINATION
                      // ==================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          _paginationButton(
                            title: "Sebelumnya",
                            onPressed:
                                provider.currentPage > 1 && !provider.isLoading
                                ? provider.previousPage
                                : null,
                          ),

                          const SizedBox(width: 15),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),

                            decoration: BoxDecoration(
                              gradient: AuthTheme.buttonGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Text(
                              "${provider.currentPage}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          _paginationButton(
                            title: "Berikutnya",
                            onPressed:
                                provider.hasNextPage && !provider.isLoading
                                ? provider.nextPage
                                : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
