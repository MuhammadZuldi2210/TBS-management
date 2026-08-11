// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

class WelcomeCard extends StatelessWidget {
  final String name;

  final String role;

  final int coinBalance;

  final VoidCallback? onTopupCoin;

  final VoidCallback? onRequestCoin;

  const WelcomeCard({
    super.key,
    required this.name,
    required this.role,
    this.coinBalance = 0,
    this.onTopupCoin,
    this.onRequestCoin,
  });

  @override
  Widget build(BuildContext context) {
    final bool showCoin = role == "admin_user" || role == "reseller";

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AuthTheme.cardBackground,
            AuthTheme.cardBackground.withOpacity(.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(26),

        border: Border.all(color: AuthTheme.border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AuthTheme.buttonGradient,
                ),

                child: Center(
                  child: Text(
                    role == "super_admin"
                        ? "👑"
                        : role == "admin_user"
                        ? "🏢"
                        : "🛒",

                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Selamat Datang 👋",

                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                    ),

                    const SizedBox(height: 4),

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

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: AuthTheme.blueGlow.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        role.replaceAll("_", " ").toUpperCase(),

                        style: const TextStyle(
                          color: AuthTheme.blueGlow,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (showCoin) ...[
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),

                color: Colors.black.withOpacity(.15),

                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),

              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,

                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(.15),
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.amber,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Coin Balance",

                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),

                        Text(
                          "$coinBalance Coin",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: onTopupCoin,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.withOpacity(.15),

                      elevation: 0,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),

                        side: BorderSide(color: Colors.amber.withOpacity(.4)),
                      ),
                    ),

                    child: const Text(
                      "+ Coin",

                      style: TextStyle(
                        color: Colors.amber,

                        fontSize: 12,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
