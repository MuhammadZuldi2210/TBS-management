// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import intl
import 'package:intl/intl.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import provider notification
import '../viewmodels/notification_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<NotificationProvider>().getNotifications();
    });
  }

  // icon berdasarkan type

  IconData _getIcon(String type) {
    switch (type) {
      case "coin":
        return Icons.monetization_on;

      case "bonus":
        return Icons.card_giftcard;

      case "module":
        return Icons.calendar_month;

      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

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
            Image.asset("assets/logos/TBS.png", height: 35),

            const SizedBox(width: 10),

            const Text(
              "Notifikasi",

              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          if (provider.unreadCount > 0)
            IconButton(
              onPressed: () {
                provider.markAllAsRead();
              },

              icon: const Icon(Icons.done_all, color: AuthTheme.blueGlow),
            ),
        ],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.notificationList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada notifikasi",

                style: TextStyle(color: AuthTheme.subtitle),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: provider.notificationList.length,

              itemBuilder: (context, index) {
                final item = provider.notificationList[index];

                final bool isRead = item["isRead"] ?? false;

                return GestureDetector(
                  onTap: () {
                    if (!isRead) {
                      provider.markAsRead(item["_id"]);
                    }
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: isRead
                          ? AuthTheme.cardBackground
                          : AuthTheme.blueGlow.withValues(alpha: .12),

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(
                        color: isRead ? AuthTheme.border : AuthTheme.blueGlow,
                      ),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 50,

                          height: 50,

                          decoration: BoxDecoration(
                            gradient: AuthTheme.buttonGradient,

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Icon(
                            _getIcon(item["type"] ?? ""),

                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                item["title"] ?? "-",

                                style: const TextStyle(
                                  color: AuthTheme.title,

                                  fontSize: 16,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                item["message"] ?? "-",

                                style: const TextStyle(
                                  color: AuthTheme.subtitle,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                item["createdAt"] != null
                                    ? DateFormat("dd MMM yyyy HH:mm").format(
                                        DateTime.parse(item["createdAt"]),
                                      )
                                    : "-",

                                style: const TextStyle(
                                  color: Colors.white38,

                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 28,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: AuthTheme.cardBackground,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border: Border.all(
                                            color: Colors.redAccent.withValues(
                                              alpha: 0.35,
                                            ),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.35,
                                              ),
                                              blurRadius: 25,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // ICON
                                            Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withValues(alpha: 0.12),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.redAccent
                                                      .withValues(alpha: 0.25),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.redAccent,
                                                size: 32,
                                              ),
                                            ),

                                            const SizedBox(height: 18),

                                            // TITLE
                                            const Text(
                                              "Hapus Notifikasi?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AuthTheme.title,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 10),

                                            // DESCRIPTION
                                            const Text(
                                              "Notifikasi ini akan dihapus secara permanen dan tidak dapat dikembalikan.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AuthTheme.subtitle,
                                                fontSize: 14,
                                                height: 1.5,
                                              ),
                                            ),

                                            const SizedBox(height: 24),

                                            // BUTTONS
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      );
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor:
                                                          AuthTheme.subtitle,
                                                      side: const BorderSide(
                                                        color: AuthTheme.border,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 14,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Batal",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      foregroundColor:
                                                          Colors.white,
                                                      elevation: 0,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 14,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Hapus",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  },
                                );

                                if (confirm == true) {
                                  await provider.deleteNotification(
                                    item["_id"],
                                  );
                                }
                              },
                            ),

                            if (!isRead)
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AuthTheme.blueGlow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
