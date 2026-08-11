// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import admin provider
import '../viewmodels/admin_provider.dart';

// import reseller user page
import 'admin_reseller_user_page.dart';

// import reseller provider
import '../../reseller_management/viewmodels/reseller_provider.dart';

// import edit reseller
import '../../reseller_management/views/edit_reseller_page.dart';

// ============================================================
// HALAMAN RESELLER MILIK ADMIN
// ============================================================

class AdminResellerPage extends StatefulWidget {
  // ID admin pemilik reseller
  final String adminId;

  const AdminResellerPage({super.key, required this.adminId});

  @override
  State<AdminResellerPage> createState() => _AdminResellerPageState();
}

class _AdminResellerPageState extends State<AdminResellerPage> {
  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<AdminProvider>().getAdminResellers(widget.adminId);
    });
  }

  // ==========================================================
  // DIALOG SUSPEND
  // ==========================================================

  Future<String?> _showSuspendDialog(BuildContext context, Map reseller) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return SuspendResellerDialog(reseller: reseller);
      },
    );
  }

  // ==========================================================
  // DIALOG AKTIFKAN
  // ==========================================================

  Future<bool?> _showActivateDialog(BuildContext context, Map reseller) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ActivateResellerDialog(reseller: reseller);
      },
    );
  }

  // ==========================================================
  // DIALOG NONAKTIFKAN
  // ==========================================================

  Future<bool?> _showDeactivateDialog(BuildContext context, Map reseller) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DeactivateResellerDialog(reseller: reseller);
      },
    );
  }

  // ==========================================================
  // SNACKBAR
  // ==========================================================

  void _showMessage(String message, {Color backgroundColor = Colors.black87}) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ======================================================
      // APPBAR
      // ======================================================
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
              "Detail Reseller",
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
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          // --------------------------------------------------
          // LOADING
          // --------------------------------------------------

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // --------------------------------------------------
          // EMPTY
          // --------------------------------------------------

          if (provider.resellerList.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada reseller",
                style: TextStyle(color: AuthTheme.subtitle),
              ),
            );
          }

          // --------------------------------------------------
          // LIST
          // --------------------------------------------------

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.resellerList.length,

            itemBuilder: (context, index) {
              final reseller = provider.resellerList[index];

              final String resellerId = reseller["_id"]?.toString() ?? "";

              final String resellerName = reseller["name"]?.toString() ?? "-";

              final String resellerEmail = reseller["email"]?.toString() ?? "-";

              final String resellerPhone = reseller["phone"]?.toString() ?? "-";

              final int coinBalance = reseller["coinBalance"] is int
                  ? reseller["coinBalance"]
                  : int.tryParse(reseller["coinBalance"]?.toString() ?? "0") ??
                        0;

              final bool isSuspended = reseller["accountStatus"] == "suspended";

              final bool isActive = reseller["isActive"] == true;

              // =================================================
              // CARD RESELLER
              // =================================================

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
                    // ===========================================
                    // PROFILE
                    // ===========================================
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
                              resellerName.isNotEmpty
                                  ? resellerName[0].toUpperCase()
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
                          child: Text(
                            resellerName,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: AuthTheme.title,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ===========================================
                    // EMAIL
                    // ===========================================
                    Text(
                      resellerEmail,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(color: AuthTheme.subtitle),
                    ),

                    const SizedBox(height: 8),

                    // ===========================================
                    // PHONE
                    // ===========================================
                    Text(
                      "Phone : $resellerPhone",

                      style: const TextStyle(color: AuthTheme.title),
                    ),

                    const SizedBox(height: 8),

                    // ===========================================
                    // COIN
                    // ===========================================
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 18,
                        ),

                        const SizedBox(width: 7),

                        Text(
                          "Coin : $coinBalance",

                          style: const TextStyle(
                            color: AuthTheme.title,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ===========================================
                    // STATUS
                    // ===========================================
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,

                          color: isSuspended
                              ? Colors.orange
                              : isActive
                              ? Colors.green
                              : Colors.red,
                        ),

                        const SizedBox(width: 8),

                        Text(
                          isSuspended
                              ? "Suspend"
                              : isActive
                              ? "Aktif"
                              : "Nonaktif",

                          style: TextStyle(
                            color: isSuspended
                                ? Colors.orange
                                : isActive
                                ? Colors.green
                                : Colors.red,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // ===========================================
                    // BUTTON GRID
                    // ===========================================
                    GridView.count(
                      crossAxisCount: 2,

                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      crossAxisSpacing: 10,

                      mainAxisSpacing: 10,

                      childAspectRatio: 3,

                      children: [
                        // =====================================
                        // LIHAT USER
                        // =====================================
                        Container(
                          decoration: BoxDecoration(
                            gradient: AuthTheme.buttonGradient,

                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),

                            onPressed: resellerId.isEmpty
                                ? null
                                : () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AdminResellerUserPage(
                                          resellerId: resellerId,
                                        ),
                                      ),
                                    );
                                  },

                            icon: const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 18,
                            ),

                            label: const Text(
                              "Lihat User",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        // =====================================
                        // EDIT
                        // =====================================
                        Container(
                          decoration: BoxDecoration(
                            gradient: AuthTheme.buttonGradient,

                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),

                            onPressed: resellerId.isEmpty
                                ? null
                                : () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditResellerPage(
                                          reseller: reseller,
                                        ),
                                      ),
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    if (result == true) {
                                      await provider.getAdminResellers(
                                        widget.adminId,
                                      );
                                    }
                                  },

                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),

                            label: const Text(
                              "Edit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        // =====================================
                        // SUSPEND / AKTIFKAN
                        // =====================================
                        Container(
                          decoration: BoxDecoration(
                            gradient: AuthTheme.buttonGradient,

                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),

                            onPressed: resellerId.isEmpty
                                ? null
                                : () async {
                                    final resellerProvider = context
                                        .read<ResellerProvider>();

                                    // =================================
                                    // AKTIFKAN DARI SUSPEND
                                    // =================================

                                    if (isSuspended) {
                                      final confirm = await _showActivateDialog(
                                        context,
                                        reseller,
                                      );

                                      if (!mounted) {
                                        return;
                                      }

                                      if (confirm != true) {
                                        return;
                                      }

                                      final result = await resellerProvider
                                          .activateReseller(resellerId);

                                      if (!mounted) {
                                        return;
                                      }

                                      if (!result) {
                                        _showMessage(
                                          "Gagal mengaktifkan reseller",
                                          backgroundColor: Colors.red,
                                        );

                                        return;
                                      }

                                      await provider.getAdminResellers(
                                        widget.adminId,
                                      );

                                      if (!mounted) {
                                        return;
                                      }

                                      _showMessage(
                                        "Reseller berhasil diaktifkan",
                                        backgroundColor: Colors.green,
                                      );

                                      return;
                                    }

                                    // =================================
                                    // SUSPEND
                                    // =================================

                                    final reason = await _showSuspendDialog(
                                      context,
                                      reseller,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    if (reason == null ||
                                        reason.trim().isEmpty) {
                                      return;
                                    }

                                    final result = await resellerProvider
                                        .suspendReseller(
                                          resellerId: resellerId,
                                          reason: reason.trim(),
                                        );

                                    if (!mounted) {
                                      return;
                                    }

                                    if (!result) {
                                      _showMessage(
                                        "Gagal men-suspend reseller",
                                        backgroundColor: Colors.red,
                                      );

                                      return;
                                    }

                                    await provider.getAdminResellers(
                                      widget.adminId,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    _showMessage(
                                      "Reseller berhasil disuspend",
                                      backgroundColor: Colors.orange,
                                    );
                                  },

                            icon: Icon(
                              isSuspended ? Icons.check_circle : Icons.block,

                              color: Colors.white,
                            ),

                            label: Text(
                              isSuspended ? "Aktifkan" : "Suspend",

                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        // =====================================
                        // NONAKTIF / AKTIFKAN
                        // =====================================
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive
                                ? Colors.red
                                : Colors.green,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          onPressed: resellerId.isEmpty
                              ? null
                              : () async {
                                  final resellerProvider = context
                                      .read<ResellerProvider>();

                                  bool result;

                                  // -----------------------------
                                  // NONAKTIFKAN
                                  // -----------------------------

                                  if (isActive) {
                                    final confirm = await _showDeactivateDialog(
                                      context,
                                      reseller,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    if (confirm != true) {
                                      return;
                                    }

                                    result = await resellerProvider
                                        .deactivateReseller(resellerId);
                                  }
                                  // -----------------------------
                                  // AKTIFKAN
                                  // -----------------------------
                                  else {
                                    // SEKARANG AKTIFKAN
                                    // TIDAK LANGSUNG API.
                                    // TAMPILKAN DIALOG DULU.

                                    final confirm = await _showActivateDialog(
                                      context,
                                      reseller,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    if (confirm != true) {
                                      return;
                                    }

                                    result = await resellerProvider
                                        .activateReseller(resellerId);
                                  }

                                  if (!mounted) {
                                    return;
                                  }

                                  if (!result) {
                                    _showMessage(
                                      "Gagal memperbarui status reseller",
                                      backgroundColor: Colors.red,
                                    );

                                    return;
                                  }

                                  await provider.getAdminResellers(
                                    widget.adminId,
                                  );

                                  if (!mounted) {
                                    return;
                                  }

                                  _showMessage(
                                    "Status reseller diperbarui",
                                    backgroundColor: Colors.green,
                                  );
                                },

                          icon: Icon(
                            isActive ? Icons.person_off : Icons.person,

                            color: Colors.white,

                            size: 18,
                          ),

                          label: Text(
                            isActive ? "Nonaktif" : "Aktifkan",

                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// DIALOG SUSPEND RESELLER
// ============================================================

class SuspendResellerDialog extends StatefulWidget {
  final Map reseller;

  const SuspendResellerDialog({super.key, required this.reseller});

  @override
  State<SuspendResellerDialog> createState() => _SuspendResellerDialogState();
}

class _SuspendResellerDialogState extends State<SuspendResellerDialog> {
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

  void _submit() {
    final reason = _controller.text.trim();

    if (reason.isEmpty) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).pop(reason);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.reseller["name"]?.toString() ?? "-";

    final email = widget.reseller["email"]?.toString() ?? "-";

    return AlertDialog(
      backgroundColor: AuthTheme.cardBackground,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),

      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

      title: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(Icons.block, color: Colors.orange),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              "Suspend Reseller",

              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Anda akan men-suspend reseller:",

              style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
            ),

            const SizedBox(height: 8),

            Text(
              name,

              style: const TextStyle(
                color: AuthTheme.title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              email,

              style: const TextStyle(color: AuthTheme.subtitle, fontSize: 12),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
              ),

              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Reseller tidak dapat menggunakan akun sampai suspend dicabut.",

                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
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

            const SizedBox(height: 8),

            TextField(
              controller: _controller,

              maxLines: 4,

              style: const TextStyle(color: AuthTheme.title, fontSize: 13),

              decoration: InputDecoration(
                hintText: "Contoh: Pelanggaran aturan penggunaan...",

                hintStyle: const TextStyle(color: AuthTheme.hint, fontSize: 12),

                filled: true,

                fillColor: AuthTheme.inputFill,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: AuthTheme.border),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: AuthTheme.border),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: const BorderSide(color: Colors.orange),
                ),

                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  Navigator.of(context).pop();
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: AuthTheme.subtitle,

                  side: BorderSide(color: AuthTheme.border),

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text("Batal"),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                onPressed: _submit,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Suspend",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// DIALOG NONAKTIFKAN RESELLER
// ============================================================

class DeactivateResellerDialog extends StatelessWidget {
  final Map reseller;

  const DeactivateResellerDialog({super.key, required this.reseller});

  @override
  Widget build(BuildContext context) {
    final name = reseller["name"]?.toString() ?? "-";

    final email = reseller["email"]?.toString() ?? "-";

    return AlertDialog(
      backgroundColor: AuthTheme.cardBackground,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),

      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

      title: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(Icons.person_off_outlined, color: Colors.red),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              "Nonaktifkan Reseller",

              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Anda akan menonaktifkan reseller:",

            style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
          ),

          const SizedBox(height: 8),

          Text(
            name,

            style: const TextStyle(
              color: AuthTheme.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            email,

            style: const TextStyle(color: AuthTheme.subtitle, fontSize: 12),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Colors.red.withValues(alpha: 0.20)),
            ),

            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),

                SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "Reseller tidak dapat menggunakan akun sampai akun diaktifkan kembali.",

                    style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: AuthTheme.subtitle,

                  side: BorderSide(color: AuthTheme.border),

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text("Batal"),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Nonaktifkan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// DIALOG AKTIFKAN RESELLER
// ============================================================

class ActivateResellerDialog extends StatelessWidget {
  final Map reseller;

  const ActivateResellerDialog({super.key, required this.reseller});

  @override
  Widget build(BuildContext context) {
    final name = reseller["name"]?.toString() ?? "-";

    final email = reseller["email"]?.toString() ?? "-";

    return AlertDialog(
      backgroundColor: AuthTheme.cardBackground,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),

      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

      // ======================================================
      // TITLE
      // ======================================================
      title: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(Icons.check_circle, color: Colors.green),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              "Aktifkan Reseller",

              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      // ======================================================
      // CONTENT
      // ======================================================
      content: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Anda akan mengaktifkan kembali reseller:",

            style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
          ),

          const SizedBox(height: 8),

          Text(
            name,

            style: const TextStyle(
              color: AuthTheme.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            email,

            style: const TextStyle(color: AuthTheme.subtitle, fontSize: 12),
          ),

          const SizedBox(height: 18),

          // =================================================
          // INFO
          // =================================================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Colors.green.withValues(alpha: 0.20)),
            ),

            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 20),

                SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "Reseller akan dapat menggunakan kembali akunnya setelah diaktifkan.",

                    style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ======================================================
      // ACTIONS
      // ======================================================
      actions: [
        Row(
          children: [
            // =================================================
            // BATAL
            // =================================================
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: AuthTheme.subtitle,

                  side: BorderSide(color: AuthTheme.border),

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text("Batal"),
              ),
            ),

            const SizedBox(width: 10),

            // =================================================
            // AKTIFKAN
            // =================================================
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Aktifkan",

                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
