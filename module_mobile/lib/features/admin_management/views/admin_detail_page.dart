// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import provider
import 'package:provider/provider.dart';

// import admin provider
import '../viewmodels/admin_provider.dart';

// import edit admin page
import 'edit_admin_page.dart';

// import admin users page
import 'admin_users_page.dart';

// import admin reseller page
import 'admin_reseller_page.dart';

class AdminDetailPage extends StatelessWidget {
  final Map<String, dynamic> admin;

  const AdminDetailPage({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    final String adminName = admin["name"]?.toString() ?? "-";

    final String adminEmail = admin["email"]?.toString() ?? "-";

    final String initial = adminName.isNotEmpty && adminName != "-"
        ? adminName[0].toUpperCase()
        : "A";

    final bool isSuspended = admin["accountStatus"] == "suspended";

    final bool isActive = admin["isActive"] == true;

    final String statusText = isSuspended
        ? "Suspend"
        : isActive
        ? "Aktif"
        : "Nonaktif";

    final Color statusColor = isSuspended
        ? Colors.orange
        : isActive
        ? Colors.green
        : Colors.red;

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ===============================
      // APP BAR
      // ===============================
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 30),

            const SizedBox(width: 10),

            const Text(
              "Detail Admin",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ===============================
      // BODY
      // ===============================
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ===============================
              // CARD PROFILE
              // ===============================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: AuthTheme.cardBackground,

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(color: AuthTheme.border),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .12),

                      blurRadius: 20,

                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // avatar
                    Container(
                      width: 82,
                      height: 82,

                      decoration: BoxDecoration(
                        gradient: AuthTheme.buttonGradient,

                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: AuthTheme.blueGlow.withValues(alpha: .25),

                            blurRadius: 20,

                            spreadRadius: 2,
                          ),
                        ],
                      ),

                      child: Center(
                        child: Text(
                          initial,

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 30,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      adminName,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: AuthTheme.title,

                        fontSize: 22,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Icon(
                          Icons.email_outlined,

                          color: AuthTheme.subtitle,

                          size: 15,
                        ),

                        const SizedBox(width: 6),

                        Flexible(
                          child: Text(
                            adminEmail,

                            textAlign: TextAlign.center,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: AuthTheme.subtitle,

                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),

                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: .10),

                        borderRadius: BorderRadius.circular(30),

                        border: Border.all(
                          color: statusColor.withValues(alpha: .20),
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Icon(
                            isSuspended
                                ? Icons.block
                                : isActive
                                ? Icons.check_circle
                                : Icons.cancel,

                            color: statusColor,

                            size: 16,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            statusText,

                            style: TextStyle(
                              color: statusColor,

                              fontSize: 12,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===============================
              // INFORMASI ADMIN
              // ===============================
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,

                    decoration: BoxDecoration(
                      color: AuthTheme.blueGlow.withValues(alpha: .10),

                      borderRadius: BorderRadius.circular(11),
                    ),

                    child: const Icon(
                      Icons.badge_outlined,

                      color: AuthTheme.blueGlow,

                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 11),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Informasi Admin",

                        style: TextStyle(
                          color: AuthTheme.title,

                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        "Informasi akun dan status admin",

                        style: TextStyle(
                          color: AuthTheme.subtitle,

                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ===============================
              // ADMIN INFORMATION CARD
              // ===============================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(6),

                decoration: BoxDecoration(
                  color: AuthTheme.cardBackground,

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(color: AuthTheme.border),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),

                      blurRadius: 18,

                      offset: const Offset(0, 7),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    _infoItem(
                      icon: Icons.admin_panel_settings_outlined,

                      iconColor: AuthTheme.blueGlow,

                      title: "Role",

                      value: admin["role"]?.toString() ?? "-",
                    ),

                    _infoDivider(),

                    _infoItem(
                      icon: Icons.monetization_on_outlined,

                      iconColor: Colors.amber,

                      title: "Coin Balance",

                      value: "${admin["coinBalance"] ?? 0} Coin",

                      valueColor: Colors.amber,
                    ),

                    _infoDivider(),

                    _infoItem(
                      icon: isSuspended
                          ? Icons.block_outlined
                          : isActive
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,

                      iconColor: statusColor,

                      title: "Status",

                      value: statusText,

                      valueColor: statusColor,

                      showBadge: true,
                    ),

                    _infoDivider(),

                    _infoItem(
                      icon: Icons.payment_outlined,

                      iconColor: Colors.purpleAccent,

                      title: "Payment Status",

                      value: admin["paymentStatus"]?.toString() ?? "-",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===============================
              // LIHAT USER
              // ===============================
              _primaryButton(
                text: "Lihat User",

                icon: Icons.people_outline,

                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => AdminUsersPage(adminId: admin["_id"]),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              // ===============================
              // LIHAT RESELLER
              // ===============================
              _primaryButton(
                text: "Lihat Reseller",

                icon: Icons.storefront_outlined,

                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => AdminResellerPage(adminId: admin["_id"]),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              // ===============================
              // EDIT ADMIN
              // ===============================
              _primaryButton(
                text: "Edit Admin",

                icon: Icons.edit_outlined,

                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => EditAdminPage(admin: admin),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              // ===============================
              // SUSPEND / AKTIFKAN SUSPEND
              // ===============================
              _primaryButton(
                text: isSuspended ? "Aktifkan Suspend" : "Suspend Admin",

                icon: isSuspended
                    ? Icons.check_circle_outline
                    : Icons.block_outlined,

                onPressed: () async {
                  final provider = context.read<AdminProvider>();

                  bool result;

                  if (admin["accountStatus"] == "suspended") {
                    final confirm = await _showActivateSuspendDialog(context);

                    if (confirm != true) {
                      return;
                    }

                    result = await provider.activateSuspend(
                      admin["_id"].toString(),
                    );
                  } else {
                    final reason = await _showSuspendReasonDialog(context);

                    if (reason == null) {
                      return;
                    }

                    result = await provider.suspendAdmin(
                      id: admin["_id"].toString(),

                      reason: reason,
                    );
                  }

                  if (result && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
              ),

              const SizedBox(height: 20),

              // ===============================
              // NONAKTIF / AKTIFKAN ADMIN
              // ===============================
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: admin["accountStatus"] == "suspended"
                        ? Colors.grey
                        : admin["isActive"] == true
                        ? Colors.red
                        : Colors.green,

                    disabledBackgroundColor: Colors.grey,

                    padding: const EdgeInsets.symmetric(vertical: 15),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  onPressed: admin["accountStatus"] == "suspended"
                      ? null
                      : () async {
                          final provider = context.read<AdminProvider>();

                          bool result;

                          if (admin["isActive"] == true) {
                            final confirm = await _showDeactivateAdminDialog(
                              context,
                            );

                            if (confirm != true) {
                              return;
                            }

                            result = await provider.deactivateAdmin(
                              admin["_id"].toString(),
                            );
                          } else {
                            final confirm = await _showActivateAdminDialog(
                              context,
                            );

                            if (confirm != true) {
                              return;
                            }

                            result = await provider.activateAdmin(
                              admin["_id"].toString(),
                            );
                          }

                          if (result && context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        admin["isActive"] == true
                            ? Icons.person_off_outlined
                            : Icons.person_outline,

                        color: Colors.white,

                        size: 19,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        admin["isActive"] == true
                            ? "Nonaktifkan Admin"
                            : "Aktifkan Admin",

                        style: const TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DIALOG SUSPEND
  // ==========================================================
  Future<String?> _showSuspendReasonDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,

      builder: (_) {
        return _SuspendReasonDialog(admin: admin);
      },
    );
  }

  // ==========================================================
  // DIALOG AKTIFKAN SUSPEND
  // ==========================================================
  Future<bool?> _showActivateSuspendDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,

      builder: (_) {
        return _ActivateSuspendDialog(admin: admin);
      },
    );
  }

  // ==========================================================
  // DIALOG NONAKTIFKAN ADMIN
  // ==========================================================
  Future<bool?> _showDeactivateAdminDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,

      builder: (_) {
        return _DeactivateAdminDialog(admin: admin);
      },
    );
  }

  // ==========================================================
  // DIALOG AKTIFKAN ADMIN
  // ==========================================================
  Future<bool?> _showActivateAdminDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,

      builder: (_) {
        return _ActivateAdminDialog(admin: admin);
      },
    );
  }

  // ==========================================================
  // PRIMARY BUTTON
  // ==========================================================
  Widget _primaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,

      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AuthTheme.buttonGradient,

          borderRadius: BorderRadius.circular(15),
        ),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,

            shadowColor: Colors.transparent,

            padding: const EdgeInsets.symmetric(vertical: 15),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          onPressed: onPressed,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(icon, color: Colors.white, size: 19),

              const SizedBox(width: 8),

              Text(
                text,

                style: const TextStyle(
                  color: Colors.white,
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
  // INFO ITEM
  // ==========================================================
  Widget _infoItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    Color? valueColor,
    bool showBadge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .10),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: iconColor, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: AuthTheme.subtitle,

                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: valueColor ?? AuthTheme.title,

                    fontSize: 14,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          if (showBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: .10),

                borderRadius: BorderRadius.circular(30),

                border: Border.all(color: iconColor.withValues(alpha: .18)),
              ),

              child: Text(
                value,

                style: TextStyle(
                  color: iconColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFO DIVIDER
  // ==========================================================
  Widget _infoDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),

      child: Divider(height: 1, color: AuthTheme.border.withValues(alpha: .65)),
    );
  }
}

// ==========================================================
// DIALOG SUSPEND
// ==========================================================

class _SuspendReasonDialog extends StatefulWidget {
  final Map<String, dynamic> admin;

  const _SuspendReasonDialog({required this.admin});

  @override
  State<_SuspendReasonDialog> createState() => _SuspendReasonDialogState();
}

class _SuspendReasonDialogState extends State<_SuspendReasonDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

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

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,

                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: .15),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.block,
                      color: Colors.orange,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Suspend Admin",

                          style: TextStyle(
                            color: AuthTheme.title,

                            fontSize: 19,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Admin akan sementara dinonaktifkan",

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

              _adminInfoCard(),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: .08),

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(
                    color: Colors.orange.withValues(alpha: .20),
                  ),
                ),

                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 19,
                    ),

                    SizedBox(width: 9),

                    Expanded(
                      child: Text(
                        "Admin yang disuspend tidak dapat menggunakan akun sampai suspend dicabut.",

                        style: TextStyle(
                          color: AuthTheme.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Alasan Suspend",

                style: TextStyle(
                  color: AuthTheme.title,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: AuthTheme.inputFill,

                  borderRadius: BorderRadius.circular(14),

                  border: Border.all(color: AuthTheme.border),
                ),

                child: TextField(
                  controller: _controller,

                  maxLines: 4,

                  textInputAction: TextInputAction.newline,

                  style: const TextStyle(color: AuthTheme.title, fontSize: 13),

                  decoration: const InputDecoration(
                    hintText: "Contoh: Pelanggaran aturan penggunaan...",

                    hintStyle: TextStyle(color: AuthTheme.hint, fontSize: 12),

                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 14, right: 8, top: 14),

                      child: Icon(
                        Icons.edit_note,
                        color: AuthTheme.subtitle,
                        size: 20,
                      ),
                    ),

                    prefixIconConstraints: BoxConstraints(
                      minWidth: 45,
                      minHeight: 45,
                    ),

                    border: InputBorder.none,

                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),

              const SizedBox(height: 22),

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
                        color: Colors.orange,

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
                          final reason = _controller.text.trim();

                          if (reason.isEmpty) {
                            return;
                          }

                          Navigator.pop(context, reason);
                        },

                        child: const Text(
                          "Suspend",

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
      ),
    );
  }

  Widget _adminInfoCard() {
    final name = widget.admin["name"]?.toString() ?? "-";

    final email = widget.admin["email"]?.toString() ?? "-";

    final initial = name.isNotEmpty && name != "-"
        ? name[0].toUpperCase()
        : "A";

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .04),

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: AuthTheme.border),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              gradient: AuthTheme.buttonGradient,

              shape: BoxShape.circle,
            ),

            child: Center(
              child: Text(
                initial,

                style: const TextStyle(
                  color: Colors.white,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Admin yang akan disuspend",

                  style: TextStyle(color: AuthTheme.subtitle, fontSize: 11),
                ),

                const SizedBox(height: 3),

                Text(
                  name,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: AuthTheme.title,

                    fontSize: 15,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  email,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: AuthTheme.subtitle,

                    fontSize: 11,
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

// ==========================================================
// DIALOG AKTIFKAN SUSPEND
// ==========================================================

class _ActivateSuspendDialog extends StatelessWidget {
  final Map<String, dynamic> admin;

  const _ActivateSuspendDialog({required this.admin});

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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .15),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Icon(
                    Icons.check_circle_outline,

                    color: Colors.green,

                    size: 27,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Aktifkan Admin",

                        style: TextStyle(
                          color: AuthTheme.title,

                          fontSize: 19,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Cabut suspend dari admin ini",

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
                    Navigator.pop(context, false);
                  },

                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .04),

                borderRadius: BorderRadius.circular(15),

                border: Border.all(color: AuthTheme.border),
              ),

              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,

                      shape: BoxShape.circle,
                    ),

                    child: Center(
                      child: Text(
                        admin["name"] != null &&
                                admin["name"].toString().isNotEmpty
                            ? admin["name"][0].toUpperCase()
                            : "A",

                        style: const TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Admin yang akan diaktifkan",

                          style: TextStyle(
                            color: AuthTheme.subtitle,

                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          admin["name"] ?? "-",

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AuthTheme.title,

                            fontSize: 15,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          admin["email"] ?? "-",

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AuthTheme.subtitle,

                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.green.withValues(alpha: .20)),
              ),

              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(Icons.info_outline, color: Colors.green, size: 19),

                  SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      "Suspend admin akan dicabut dan admin dapat kembali menggunakan akunnya.",

                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

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
                      Navigator.pop(context, false);
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
                      color: Colors.green,

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
                        Navigator.pop(context, true);
                      },

                      child: const Text(
                        "Aktifkan",

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
}

// ==========================================================
// DIALOG AKTIFKAN ADMIN
// ==========================================================

class _ActivateAdminDialog extends StatelessWidget {
  final Map<String, dynamic> admin;

  const _ActivateAdminDialog({required this.admin});

  @override
  Widget build(BuildContext context) {
    final String name = admin["name"]?.toString() ?? "-";

    final String email = admin["email"]?.toString() ?? "-";

    final String initial = name.isNotEmpty && name != "-"
        ? name[0].toUpperCase()
        : "A";

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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .15),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Icon(
                    Icons.person_outline,

                    color: Colors.green,

                    size: 27,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Aktifkan Admin",

                        style: TextStyle(
                          color: AuthTheme.title,

                          fontSize: 19,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Aktifkan kembali akun admin ini",

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
                    Navigator.pop(context, false);
                  },

                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .04),

                borderRadius: BorderRadius.circular(15),

                border: Border.all(color: AuthTheme.border),
              ),

              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,

                      shape: BoxShape.circle,
                    ),

                    child: Center(
                      child: Text(
                        initial,

                        style: const TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Admin yang akan diaktifkan",

                          style: TextStyle(
                            color: AuthTheme.subtitle,

                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          name,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AuthTheme.title,

                            fontSize: 15,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          email,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AuthTheme.subtitle,

                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.green.withValues(alpha: .20)),
              ),

              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.check_circle_outline,

                    color: Colors.green,

                    size: 19,
                  ),

                  SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      "Admin akan dapat kembali menggunakan akun setelah diaktifkan.",

                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

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
                      Navigator.pop(context, false);
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
                      color: Colors.green,

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
                        Navigator.pop(context, true);
                      },

                      child: const Text(
                        "Aktifkan",

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
}

// ==========================================================
// DIALOG NONAKTIFKAN ADMIN
// ==========================================================

class _DeactivateAdminDialog extends StatelessWidget {
  final Map<String, dynamic> admin;

  const _DeactivateAdminDialog({required this.admin});

  @override
  Widget build(BuildContext context) {
    final String name = admin["name"]?.toString() ?? "-";

    final String email = admin["email"]?.toString() ?? "-";

    final String initial = name.isNotEmpty && name != "-"
        ? name[0].toUpperCase()
        : "A";

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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: .15),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Icon(
                    Icons.person_off_outlined,

                    color: Colors.red,

                    size: 27,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Nonaktifkan Admin",

                        style: TextStyle(
                          color: AuthTheme.title,

                          fontSize: 19,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Nonaktifkan akses akun admin ini",

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
                    Navigator.pop(context, false);
                  },

                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .04),

                borderRadius: BorderRadius.circular(15),

                border: Border.all(color: AuthTheme.border),
              ),

              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,

                      shape: BoxShape.circle,
                    ),

                    child: Center(
                      child: Text(
                        initial,

                        style: const TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Admin yang akan dinonaktifkan",

                          style: TextStyle(
                            color: AuthTheme.subtitle,

                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          name,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AuthTheme.title,

                            fontSize: 15,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          email,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AuthTheme.subtitle,

                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.red.withValues(alpha: .20)),
              ),

              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.warning_amber_rounded,

                    color: Colors.red,

                    size: 19,
                  ),

                  SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      "Admin yang dinonaktifkan tidak dapat menggunakan akun sampai diaktifkan kembali.",

                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

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
                      Navigator.pop(context, false);
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
                      color: Colors.red,

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
                        Navigator.pop(context, true);
                      },

                      child: const Text(
                        "Nonaktifkan",

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
}
