import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/auth_theme.dart';

import '../../auth/viewmodels/auth_provider.dart';

import '../../admin_management/services/admin_service.dart';

import '../../user_management/services/user_management_service.dart';
import '../../user_management/viewmodels/user_management_provider.dart';
import '../../user_management/views/edit_user_page.dart';
import '../../user_management/widgets/extend_module_dialog.dart';

import '../viewmodels/reseller_provider.dart';

class ResellerUserPage extends StatefulWidget {
  final String resellerId;

  const ResellerUserPage({super.key, required this.resellerId});

  @override
  State<ResellerUserPage> createState() => _ResellerUserPageState();
}

class _ResellerUserPageState extends State<ResellerUserPage> {
  final AdminService adminService = AdminService();
  final UserManagementService userService = UserManagementService();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<ResellerProvider>().getResellerUsers(widget.resellerId);
    });
  }

  // ============================================================
  // DIALOG PINDAH USER
  // ============================================================

  Future<void> showTransferDialog(dynamic user) async {
    final pageContext = context;

    try {
      final owners = await adminService.getTransferOwners();

      if (!mounted) return;

      String? selectedOwner;

      await showDialog(
        context: pageContext,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setStateDialog) {
              final selectedOwnerData = selectedOwner == null
                  ? null
                  : owners.cast<Map<String, dynamic>>().firstWhere(
                      (owner) => owner["_id"] == selectedOwner,
                      orElse: () => <String, dynamic>{},
                    );

              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
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
                                gradient: AuthTheme.buttonGradient,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.swap_horiz,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pindah User",
                                    style: TextStyle(
                                      color: AuthTheme.title,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Pilih pemilik baru untuk user",
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
                                Navigator.pop(dialogContext);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white54,
                              ),
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
                                    user["name"] != null &&
                                            user["name"].toString().isNotEmpty
                                        ? user["name"][0].toUpperCase()
                                        : "U",
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
                                      "User yang dipindahkan",
                                      style: TextStyle(
                                        color: AuthTheme.subtitle,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      user["name"] ?? "-",
                                      style: const TextStyle(
                                        color: AuthTheme.title,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user["email"] ?? "-",
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

                        const Text(
                          "Pilih Owner Baru",
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
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedOwner,
                              isExpanded: true,
                              dropdownColor: AuthTheme.cardBackground,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AuthTheme.blueGlow,
                              ),
                              hint: const Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: AuthTheme.subtitle,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Pilih pemilik baru",
                                    style: TextStyle(color: AuthTheme.hint),
                                  ),
                                ],
                              ),
                              items: owners.map<DropdownMenuItem<String>>((
                                owner,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: owner["_id"],
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: AuthTheme.blueGlow.withValues(
                                            alpha: .12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          owner["role"] == "reseller"
                                              ? Icons.storefront
                                              : Icons.admin_panel_settings,
                                          color: AuthTheme.blueGlow,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              owner["name"] ?? "-",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: AuthTheme.title,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              (owner["role"] ?? "-")
                                                  .toString()
                                                  .replaceAll("_", " ")
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: AuthTheme.subtitle,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setStateDialog(() {
                                  selectedOwner = value;
                                });
                              },
                            ),
                          ),
                        ),

                        if (selectedOwnerData != null &&
                            selectedOwnerData.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AuthTheme.blueGlow.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AuthTheme.blueGlow.withValues(
                                  alpha: .20,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AuthTheme.blueGlow,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "User akan dipindahkan ke ${selectedOwnerData["name"] ?? "-"}",
                                    style: const TextStyle(
                                      color: AuthTheme.subtitle,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AuthTheme.subtitle,
                                  side: BorderSide(color: AuthTheme.border),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(dialogContext);
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  ),
                                  onPressed: selectedOwner == null
                                      ? null
                                      : () async {
                                          try {
                                            await userService.transferUser(
                                              user["_id"],
                                              selectedOwner!,
                                            );

                                            if (!mounted) return;

                                            Navigator.pop(dialogContext);

                                            await pageContext
                                                .read<ResellerProvider>()
                                                .getResellerUsers(
                                                  widget.resellerId,
                                                );

                                            if (!mounted) return;

                                            ScaffoldMessenger.of(
                                              pageContext,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "User berhasil dipindahkan",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            if (!mounted) return;

                                            ScaffoldMessenger.of(
                                              pageContext,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Gagal memindahkan user: $e",
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                  child: const Text(
                                    "Pindahkan",
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
            },
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengambil daftar owner"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // DIALOG SUSPEND USER
  // ============================================================

  Future<void> showSuspendDialog(dynamic user) async {
    final result = await showDialog(
      context: context,
      builder: (_) {
        return _SuspendUserDialog(user: user);
      },
    );

    if (result != true) return;

    if (!mounted) return;

    await context.read<ResellerProvider>().getResellerUsers(widget.resellerId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User berhasil disuspend"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // ============================================================
  // DIALOG AKTIFKAN SUSPEND
  // ============================================================

  Future<void> showActivateSuspendDialog(dynamic user) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
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
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Aktifkan Suspend",
                                  style: TextStyle(
                                    color: AuthTheme.title,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "User akan dapat menggunakan akun kembali",
                                  style: TextStyle(
                                    color: AuthTheme.subtitle,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pop(dialogContext);
                                  },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white54,
                            ),
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
                                color: Colors.green.withValues(alpha: .15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  user["name"] != null &&
                                          user["name"].toString().isNotEmpty
                                      ? user["name"][0].toUpperCase()
                                      : "U",
                                  style: const TextStyle(
                                    color: Colors.green,
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
                                    "User yang akan diaktifkan",
                                    style: TextStyle(
                                      color: AuthTheme.subtitle,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    user["name"] ?? "-",
                                    style: const TextStyle(
                                      color: AuthTheme.title,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user["email"] ?? "-",
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

                      const SizedBox(height: 14),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: .20),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.green,
                              size: 19,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Suspend user akan dihapus dan user dapat menggunakan akun kembali.",
                                style: TextStyle(
                                  color: AuthTheme.subtitle,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pop(dialogContext);
                                    },
                              child: const Text(
                                "Batal",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      setDialogState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await userService.activateSuspendUser(
                                          user["_id"],
                                        );

                                        if (!mounted) return;

                                        Navigator.pop(dialogContext);

                                        await context
                                            .read<ResellerProvider>()
                                            .getResellerUsers(
                                              widget.resellerId,
                                            );

                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "User berhasil diaktifkan kembali",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        if (!mounted) return;

                                        setDialogState(() {
                                          isLoading = false;
                                        });

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Gagal mengaktifkan user: $e",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle, size: 18),
                                        SizedBox(width: 7),
                                        Text(
                                          "Aktifkan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
          },
        );
      },
    );
  }

  // ============================================================
  // DIALOG NONAKTIFKAN USER
  // ============================================================

  Future<void> showDeactivateDialog(dynamic user) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
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
                      // ==================================================
                      // HEADER
                      // ==================================================
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
                              Icons.person_off,
                              color: Colors.red,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nonaktifkan User",
                                  style: TextStyle(
                                    color: AuthTheme.title,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "User akan dinonaktifkan",
                                  style: TextStyle(
                                    color: AuthTheme.subtitle,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pop(dialogContext);
                                  },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // INFO USER
                      // ==================================================
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
                                color: Colors.red.withValues(alpha: .15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  user["name"] != null &&
                                          user["name"].toString().isNotEmpty
                                      ? user["name"][0].toUpperCase()
                                      : "U",
                                  style: const TextStyle(
                                    color: Colors.red,
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
                                    "User yang akan dinonaktifkan",
                                    style: TextStyle(
                                      color: AuthTheme.subtitle,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    user["name"] ?? "-",
                                    style: const TextStyle(
                                      color: AuthTheme.title,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user["email"] ?? "-",
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

                      const SizedBox(height: 14),

                      // ==================================================
                      // WARNING
                      // ==================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: .20),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 19,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "User yang dinonaktifkan tidak dapat menggunakan akun sampai diaktifkan kembali.",
                                style: TextStyle(
                                  color: AuthTheme.subtitle,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // BUTTON
                      // ==================================================
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AuthTheme.subtitle,
                                side: BorderSide(color: AuthTheme.border),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pop(dialogContext);
                                    },
                              child: const Text(
                                "Batal",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      setDialogState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await userService.deactivateUser(
                                          user["_id"],
                                        );

                                        if (!mounted) return;

                                        Navigator.pop(dialogContext);

                                        await context
                                            .read<ResellerProvider>()
                                            .getResellerUsers(
                                              widget.resellerId,
                                            );

                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "User berhasil dinonaktifkan",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } catch (e) {
                                        if (!mounted) return;

                                        setDialogState(() {
                                          isLoading = false;
                                        });

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Gagal menonaktifkan user: $e",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_off, size: 18),
                                        SizedBox(width: 7),
                                        Text(
                                          "Nonaktifkan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
          },
        );
      },
    );
  }

  // ============================================================
  // DIALOG AKTIFKAN USER
  // ============================================================

  Future<void> showActivateDialog(dynamic user) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
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
                      // ==================================================
                      // HEADER
                      // ==================================================
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
                              Icons.person,
                              color: Colors.green,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Aktifkan User",
                                  style: TextStyle(
                                    color: AuthTheme.title,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "User akan diaktifkan kembali",
                                  style: TextStyle(
                                    color: AuthTheme.subtitle,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pop(dialogContext);
                                  },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // INFO USER
                      // ==================================================
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
                                color: Colors.green.withValues(alpha: .15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  user["name"] != null &&
                                          user["name"].toString().isNotEmpty
                                      ? user["name"][0].toUpperCase()
                                      : "U",
                                  style: const TextStyle(
                                    color: Colors.green,
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
                                    "User yang akan diaktifkan",
                                    style: TextStyle(
                                      color: AuthTheme.subtitle,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    user["name"] ?? "-",
                                    style: const TextStyle(
                                      color: AuthTheme.title,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user["email"] ?? "-",
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

                      const SizedBox(height: 14),

                      // ==================================================
                      // INFO
                      // ==================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: .20),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.green,
                              size: 19,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "User yang diaktifkan kembali dapat menggunakan akun seperti biasa.",
                                style: TextStyle(
                                  color: AuthTheme.subtitle,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // BUTTON
                      // ==================================================
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AuthTheme.subtitle,
                                side: BorderSide(color: AuthTheme.border),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pop(dialogContext);
                                    },
                              child: const Text(
                                "Batal",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      setDialogState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await userService.activateUser(
                                          user["_id"],
                                        );

                                        if (!mounted) return;

                                        Navigator.pop(dialogContext);

                                        await context
                                            .read<ResellerProvider>()
                                            .getResellerUsers(
                                              widget.resellerId,
                                            );

                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "User berhasil diaktifkan",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        if (!mounted) return;

                                        setDialogState(() {
                                          isLoading = false;
                                        });

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Gagal mengaktifkan user: $e",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person, size: 18),
                                        SizedBox(width: 7),
                                        Text(
                                          "Aktifkan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
          },
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResellerProvider>();

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
            Image.asset("assets/logos/TBS.png", height: 30),

            const SizedBox(width: 10),

            const Text(
              "User reseller",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Builder(
          builder: (_) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.resellerUserList.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada user",
                  style: TextStyle(color: AuthTheme.subtitle),
                ),
              );
            }

            return ListView.builder(
              itemCount: provider.resellerUserList.length,

              itemBuilder: (context, index) {
                final user = provider.resellerUserList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),

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
                      // ========================================
                      // DATA USER
                      // ========================================
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
                                user["name"] != null &&
                                        user["name"].toString().isNotEmpty
                                    ? user["name"][0].toUpperCase()
                                    : "U",
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
                                  user["name"] ?? "-",
                                  style: const TextStyle(
                                    color: AuthTheme.title,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  user["email"] ?? "-",
                                  style: const TextStyle(
                                    color: AuthTheme.subtitle,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  user["phone"] ?? "-",
                                  style: const TextStyle(
                                    color: AuthTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // ========================================
                      // STATUS USER
                      // ========================================
                      Builder(
                        builder: (_) {
                          Color accountColor;
                          String accountText;

                          if (user["accountStatus"] == "suspended") {
                            accountColor = Colors.orange;
                            accountText = "Suspend";
                          } else if (user["isActive"] == false) {
                            accountColor = Colors.red;
                            accountText = "Nonaktif";
                          } else {
                            accountColor = Colors.green;
                            accountText = "Aktif";
                          }

                          final expiredAt = user["moduleExpiredAt"];

                          bool isExpired = true;
                          String expiredText = "Belum diperpanjang";

                          if (expiredAt != null) {
                            try {
                              final date = DateTime.parse(expiredAt.toString());

                              isExpired = date.isBefore(DateTime.now());

                              expiredText = DateFormat(
                                "dd MMMM yyyy",
                              ).format(date);
                            } catch (_) {
                              isExpired = true;
                              expiredText = "Tanggal tidak valid";
                            }
                          }

                          return Container(
                            padding: const EdgeInsets.all(15),

                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified_user,
                                      color: accountColor,
                                      size: 20,
                                    ),

                                    const SizedBox(width: 10),

                                    const Expanded(
                                      child: Text(
                                        "Status Akun",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          color: AuthTheme.subtitle,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: accountColor.withValues(
                                          alpha: .15,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        accountText,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          color: accountColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(height: 25),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.workspace_premium,
                                      color: isExpired
                                          ? Colors.red
                                          : Colors.green,
                                      size: 20,
                                    ),

                                    const SizedBox(width: 10),

                                    const Expanded(
                                      child: Text(
                                        "Status Modul",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          color: AuthTheme.subtitle,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            (isExpired
                                                    ? Colors.red
                                                    : Colors.green)
                                                .withValues(alpha: .15),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        isExpired ? "Expired" : "Aktif",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          color: isExpired
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.white54,
                                      size: 18,
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Text(
                                        expiredText,
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 13,
                                          color: AuthTheme.subtitle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 15),

                      // ========================================
                      // TOMBOL AKSI
                      // ========================================
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3,

                        children: [
                          // ==================================
                          // EDIT
                          // ==================================
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

                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditUserPage(user: user),
                                  ),
                                );

                                if (result == true && mounted) {
                                  await context
                                      .read<ResellerProvider>()
                                      .getResellerUsers(widget.resellerId);
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

                          // ==================================
                          // PERPANJANG
                          // ==================================
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

                              onPressed: () async {
                                final days = await showDialog<int>(
                                  context: context,
                                  builder: (_) => const ExtendModuleDialog(),
                                );

                                if (days == null || !mounted) {
                                  return;
                                }

                                final userProvider =
                                    Provider.of<UserManagementProvider>(
                                      context,
                                      listen: false,
                                    );

                                await userProvider.extendModule(
                                  user["_id"],
                                  days,
                                  context.read<AuthProvider>(),
                                );

                                if (!mounted) return;

                                await context
                                    .read<ResellerProvider>()
                                    .getResellerUsers(widget.resellerId);

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Modul diperpanjang $days hari",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 18,
                              ),

                              label: const Text(
                                "Perpanjang",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          // ==================================
                          // PINDAH
                          // ==================================
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

                              onPressed: () async {
                                await showTransferDialog(user);
                              },

                              icon: const Icon(
                                Icons.swap_horiz,
                                color: Colors.white,
                                size: 18,
                              ),

                              label: const Text(
                                "Pindah",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          // ==================================
                          // SUSPEND
                          // ==================================
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

                              onPressed: () async {
                                if (user["accountStatus"] == "suspended") {
                                  await showActivateSuspendDialog(user);
                                } else {
                                  await showSuspendDialog(user);
                                }
                              },

                              icon: Icon(
                                user["accountStatus"] == "suspended"
                                    ? Icons.check_circle
                                    : Icons.block,
                                color: Colors.white,
                                size: 18,
                              ),

                              label: Text(
                                user["accountStatus"] == "suspended"
                                    ? "Aktifkan"
                                    : "Suspend",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          // ==================================
                          // NONAKTIF / AKTIFKAN
                          // ==================================
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user["isActive"] == true
                                  ? Colors.red
                                  : Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            onPressed: () async {
                              if (user["isActive"] == true) {
                                await showDeactivateDialog(user);
                              } else {
                                await showActivateDialog(user);
                              }
                            },

                            icon: Icon(
                              user["isActive"] == true
                                  ? Icons.person_off
                                  : Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),

                            label: Text(
                              user["isActive"] == true
                                  ? "Nonaktif"
                                  : "Aktifkan",
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
      ),
    );
  }
}

// ================================================================
// DIALOG SUSPEND USER
// ================================================================

class _SuspendUserDialog extends StatefulWidget {
  final dynamic user;

  const _SuspendUserDialog({required this.user});

  @override
  State<_SuspendUserDialog> createState() => _SuspendUserDialogState();
}

class _SuspendUserDialogState extends State<_SuspendUserDialog> {
  late final TextEditingController reasonController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();

    super.dispose();
  }

  Future<void> submitSuspend() async {
    final reason = reasonController.text.trim();

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alasan suspend wajib diisi"),
          backgroundColor: Colors.orange,
        ),
      );

      return;
    }

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userService = UserManagementService();

      await userService.suspendUser(widget.user["_id"], reason);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal suspend user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),

      child: SingleChildScrollView(
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
              // ==================================================
              // HEADER
              // ==================================================
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
                          "Suspend User",
                          style: TextStyle(
                            color: AuthTheme.title,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "User akan dinonaktifkan sementara",
                          style: TextStyle(
                            color: AuthTheme.subtitle,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    icon: const Icon(Icons.close, color: Colors.white54),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ==================================================
              // INFO USER
              // ==================================================
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
                        color: Colors.orange.withValues(alpha: .15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user["name"] != null &&
                                  user["name"].toString().isNotEmpty
                              ? user["name"][0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                            color: Colors.orange,
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
                            "User yang akan disuspend",
                            style: TextStyle(
                              color: AuthTheme.subtitle,
                              fontSize: 11,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            user["name"] ?? "-",
                            style: const TextStyle(
                              color: AuthTheme.title,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            user["email"] ?? "-",
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

              const Text(
                "Alasan Suspend",
                style: TextStyle(
                  color: AuthTheme.title,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: reasonController,
                enabled: !isLoading,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Masukkan alasan suspend...",
                  hintStyle: const TextStyle(
                    color: AuthTheme.hint,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: AuthTheme.inputFill,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 14, right: 10, top: 14),
                    child: Icon(Icons.edit_note, color: Colors.orange),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 45,
                    minHeight: 45,
                  ),
                  contentPadding: const EdgeInsets.all(14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AuthTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AuthTheme.border),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // WARNING
              // ==================================================
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

                    SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "User yang disuspend tidak dapat menggunakan akun sampai suspend diaktifkan kembali.",
                        style: TextStyle(
                          color: AuthTheme.subtitle,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // BUTTON
              // ==================================================
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
                      onPressed: isLoading
                          ? null
                          : () {
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      onPressed: isLoading ? null : submitSuspend,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.block, size: 18),
                                SizedBox(width: 7),
                                Text(
                                  "Suspend",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
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
}
