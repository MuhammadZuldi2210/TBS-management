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
      context.read<TransactionProvider>().getTransactions();
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
                  // Loading
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

                  return ListView.builder(
                    itemCount: provider.transactionList.length,

                    itemBuilder: (context, index) {
                      final transaction = provider.transactionList[index];

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
                      // AMBIL REQUEST TO ID
                      // ==================================
                      //
                      // requestTo bisa:
                      //
                      // Map:
                      // {
                      //   "_id": "...",
                      //   "name": "...",
                      //   "role": "admin_user"
                      // }
                      //
                      // atau String:
                      // "ID_USER"
                      //
                      // ==================================

                      final String? requestToId = requestTo is Map
                          ? requestTo["_id"]?.toString()
                          : requestTo?.toString();

                      // ==================================
                      // CEK APAKAH USER LOGIN ADALAH
                      // PENERIMA REQUEST
                      // ==================================

                      final bool isRequestReceiver =
                          requestToId != null &&
                          requestToId == auth.userId?.toString();

                      // ==================================
                      // CEK APAKAH BOLEH APPROVE
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
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // ==================================
                            // HEADER
                            // ==================================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      type == "module_extension"
                                          ? Icons.calendar_month
                                          : type == "coin_topup"
                                          ? Icons.account_balance_wallet
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
                                        ? Colors.green.withOpacity(.15)
                                        : Colors.orange.withOpacity(.15),

                                    borderRadius: BorderRadius.circular(20),
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
                              style: const TextStyle(color: AuthTheme.subtitle),
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
                            //
                            // Akan muncul jika:
                            //
                            // Admin menerima request
                            // dari Reseller
                            //
                            // ATAU
                            //
                            // Super Admin menerima request
                            // dari Admin
                            //
                            // ==================================
                            if (canApprove) ...[
                              const SizedBox(height: 15),

                              SizedBox(
                                width: double.infinity,

                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),

                                  onPressed: () async {
                                    final transactionProvider = context
                                        .read<TransactionProvider>();

                                    final success = await transactionProvider
                                        .approveTransaction(id, auth);

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
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      // Refresh dashboard
                                      await context
                                          .read<AdminDashboardProvider>()
                                          .getDashboardStats();

                                      // Refresh transaksi
                                      await context
                                          .read<TransactionProvider>()
                                          .getTransactions(
                                            type: provider.selectedType,
                                            status: provider.selectedStatus,
                                          );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            transactionProvider.errorMessage ??
                                                "Gagal approve request coin",
                                          ),
                                          backgroundColor: Colors.redAccent,
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
