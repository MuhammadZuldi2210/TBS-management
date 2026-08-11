// import flutter
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import coin provider
import '../viewmodels/coin_provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

class RequestCoinDialog extends StatefulWidget {
  // ID user yang akan menerima request coin
  final String requestTo;

  const RequestCoinDialog({super.key, required this.requestTo});

  @override
  State<RequestCoinDialog> createState() => _RequestCoinDialogState();
}

class _RequestCoinDialogState extends State<RequestCoinDialog> {
  final TextEditingController coinController = TextEditingController();

  @override
  void dispose() {
    coinController.dispose();
    super.dispose();
  }

  // ===============================
  // SUBMIT REQUEST COIN
  // ===============================
  Future<void> submit() async {
    final amount = int.tryParse(coinController.text.trim());

    // Validasi jumlah coin
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Jumlah coin tidak valid")));

      return;
    }

    // Request coin
    final success = await context.read<CoinProvider>().requestCoin(
      requestTo: widget.requestTo,
      amount: amount,
    );

    if (!mounted) return;

    // Jika gagal
    if (!success) {
      final error = context.read<CoinProvider>().errorMessage;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? "Request coin gagal")));

      return;
    }

    // Tutup dialog
    Navigator.pop(context);

    // Pesan berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Request coin berhasil dikirim")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoinProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          color: AuthTheme.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AuthTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // ===============================
            // ICON COIN
            // ===============================
            Container(
              width: 70,
              height: 70,

              decoration: BoxDecoration(
                gradient: AuthTheme.buttonGradient,
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: AuthTheme.blueGlow.withOpacity(.4),
                    blurRadius: 15,
                  ),
                ],
              ),

              child: const Icon(
                Icons.monetization_on_rounded,
                color: Colors.amber,
                size: 38,
              ),
            ),

            const SizedBox(height: 16),

            // ===============================
            // TITLE
            // ===============================
            const Text(
              "Request Coin",

              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Masukkan jumlah coin yang ingin kamu request",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white.withOpacity(.6),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            // ===============================
            // INPUT COIN
            // ===============================
            TextField(
              controller: coinController,

              keyboardType: TextInputType.number,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

              decoration: InputDecoration(
                hintText: "Jumlah Coin",

                hintStyle: TextStyle(color: Colors.white.withOpacity(.4)),

                prefixIcon: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.amber,
                ),

                filled: true,

                fillColor: Colors.white.withOpacity(.05),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),

                  borderSide: BorderSide(color: Colors.white.withOpacity(.12)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),

                  borderSide: BorderSide(color: AuthTheme.blueGlow),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ===============================
            // BUTTON
            // ===============================
            Row(
              children: [
                // ===============================
                // BATAL
                // ===============================
                Expanded(
                  child: OutlinedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },

                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      side: BorderSide(color: Colors.white.withOpacity(.15)),
                    ),

                    child: const Text(
                      "Batal",

                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ===============================
                // KIRIM
                // ===============================
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : submit,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: AuthTheme.buttonGradient,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Container(
                        width: double.infinity,

                        padding: const EdgeInsets.symmetric(vertical: 14),

                        alignment: Alignment.center,

                        child: provider.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,

                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Kirim",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
