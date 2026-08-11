import 'package:flutter/material.dart';

import '../../../core/theme/auth_theme.dart';

class ExtendModuleDialog extends StatefulWidget {
  const ExtendModuleDialog({super.key});

  @override
  State<ExtendModuleDialog> createState() => _ExtendModuleDialogState();
}

class _ExtendModuleDialogState extends State<ExtendModuleDialog> {
  int selectedDays = 30;

  // ==========================
  // DATA PILIHAN
  // ==========================
  final List<Map<String, dynamic>> durationOptions = [
    {
      "days": 30,
      "coin": 1,
      "label": "30 Hari",
      "subtitle": "Perpanjangan 1 bulan",
    },
    {
      "days": 60,
      "coin": 2,
      "label": "60 Hari",
      "subtitle": "Perpanjangan 2 bulan",
    },
    {
      "days": 90,
      "coin": 3,
      "label": "90 Hari",
      "subtitle": "Perpanjangan 3 bulan",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AuthTheme.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AuthTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================
            // HEADER
            // ==========================
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AuthTheme.buttonGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Perpanjang Modul",
                        style: TextStyle(
                          color: AuthTheme.title,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Pilih durasi perpanjangan",
                        style: TextStyle(
                          color: AuthTheme.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ==========================
            // PILIHAN DURASI
            // ==========================
            ...durationOptions.map(
              (option) => _durationCard(
                days: option["days"],
                coin: option["coin"],
                label: option["label"],
                subtitle: option["subtitle"],
              ),
            ),

            const SizedBox(height: 18),

            // ==========================
            // INFO
            // ==========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AuthTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AuthTheme.blueGlow,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "1 Coin digunakan untuk perpanjangan 30 hari.",
                      style: const TextStyle(
                        color: AuthTheme.subtitle,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // BUTTON
            // ==========================
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AuthTheme.subtitle,
                      side: BorderSide(color: AuthTheme.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Batal",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
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
                      onPressed: () {
                        Navigator.pop(context, selectedDays);
                      },
                      child: const Text(
                        "Lanjut",
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
          ],
        ),
      ),
    );
  }

  // ==========================
  // DURATION CARD
  // ==========================
  Widget _durationCard({
    required int days,
    required int coin,
    required String label,
    required String subtitle,
  }) {
    final bool selected = selectedDays == days;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDays = days;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: selected ? AuthTheme.buttonGradient : null,
          color: selected ? null : Colors.white.withValues(alpha: .04),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? Colors.transparent : AuthTheme.border,
          ),
        ),
        child: Row(
          children: [
            // ICON
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: .15)
                    : AuthTheme.blueGlow.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_today,
                color: selected ? Colors.white : AuthTheme.blueGlow,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.white : AuthTheme.title,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: selected ? Colors.white70 : AuthTheme.subtitle,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // COIN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: .15)
                    : Colors.amber.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: selected ? Colors.white : Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$coin Coin",
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.amber,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
