// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import intl
import 'package:intl/intl.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import user provider
import '../../user_management/viewmodels/user_management_provider.dart';
import '../../user_management/services/user_management_service.dart';

// import auth provider
import '../../auth/viewmodels/auth_provider.dart';

// import edit user
import '../../user_management/views/edit_user_page.dart';

// import extend module dialog
import '../../user_management/widgets/extend_module_dialog.dart';

// import admin service
import '../../admin_management/services/admin_service.dart';

class AdminAllUserPage extends StatefulWidget {
  const AdminAllUserPage({super.key});

  @override
  State<AdminAllUserPage> createState() => _AdminAllUserPageState();
}

class _AdminAllUserPageState extends State<AdminAllUserPage> {
  final UserManagementService userService = UserManagementService();

  final AdminService adminService = AdminService();

  final TextEditingController searchController = TextEditingController();

  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<UserManagementProvider>().getUsers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // DIALOG PINDAH USER
  // ============================================================
  Future<void> showTransferDialog(dynamic user) async {
    try {
      final owners = await adminService.getTransferOwners();

      if (!mounted) return;

      String? selectedOwner;

      await showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              final selectedOwnerData = selectedOwner == null
                  ? null
                  : owners.cast<Map<String, dynamic>>().firstWhere(
                      (owner) => owner["_id"] == selectedOwner,
                      orElse: () => <String, dynamic>{},
                    );

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
                      // HEADER
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
                              Navigator.of(dialogContext).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // INFO USER
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
                                      ? user["name"]
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase()
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
                                        borderRadius: BorderRadius.circular(10),
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
                              color: AuthTheme.blueGlow.withValues(alpha: .20),
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
                                Navigator.of(dialogContext).pop();
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

                                          if (!dialogContext.mounted) return;

                                          Navigator.of(dialogContext).pop();

                                          if (!mounted) return;

                                          await context
                                              .read<UserManagementProvider>()
                                              .getUsers();

                                          if (!mounted) return;

                                          ScaffoldMessenger.maybeOf(
                                            context,
                                          )?.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "User berhasil dipindahkan",
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } catch (e) {
                                          if (!dialogContext.mounted) return;

                                          ScaffoldMessenger.maybeOf(
                                            dialogContext,
                                          )?.showSnackBar(
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
              );
            },
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
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
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
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
                    // HEADER
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
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  Navigator.of(dialogContext).pop(false);
                                },
                          icon: const Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // USER INFO
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
                                    ? user["name"]
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase()
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

                    // INPUT ALASAN
                    TextField(
                      controller: reasonController,
                      enabled: !isSubmitting,
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
                          padding: EdgeInsets.only(
                            left: 14,
                            right: 10,
                            top: 14,
                          ),
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
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AuthTheme.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // WARNING
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

                    // BUTTON
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
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    Navigator.of(dialogContext).pop(false);
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
                              disabledBackgroundColor: Colors.orange.withValues(
                                alpha: .5,
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    final reason = reasonController.text.trim();

                                    if (reason.isEmpty) {
                                      ScaffoldMessenger.maybeOf(
                                        dialogContext,
                                      )?.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Alasan suspend wajib diisi",
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }

                                    setDialogState(() {
                                      isSubmitting = true;
                                    });

                                    try {
                                      await userService.suspendUser(
                                        user["_id"],
                                        reason,
                                      );

                                      if (!dialogContext.mounted) {
                                        return;
                                      }

                                      // Hanya tutup dialog.
                                      Navigator.of(dialogContext).pop(true);
                                    } catch (e) {
                                      if (!dialogContext.mounted) {
                                        return;
                                      }

                                      setDialogState(() {
                                        isSubmitting = false;
                                      });

                                      ScaffoldMessenger.maybeOf(
                                        dialogContext,
                                      )?.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Gagal suspend user: $e",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
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
            );
          },
        );
      },
    );

    reasonController.dispose();

    // Dialog sudah benar-benar selesai ditutup
    if (result != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    try {
      final provider = context.read<UserManagementProvider>();

      await provider.getUsers();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text("User berhasil disuspend"),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text("Suspend berhasil, tetapi gagal refresh data: $e"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // ============================================================
  // DIALOG AKTIFKAN SUSPEND
  // ============================================================
  Future<void> showActivateSuspendDialog(dynamic user) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
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
                  children: [
                    // ICON
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Aktifkan User",
                      style: TextStyle(
                        color: AuthTheme.title,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Apakah kamu yakin ingin mengaktifkan kembali ${user["name"] ?? "user"}?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AuthTheme.subtitle,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: .18),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.green,
                            size: 18,
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    Navigator.of(dialogContext).pop(false);
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
                              disabledBackgroundColor: Colors.green.withValues(
                                alpha: .5,
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    setDialogState(() {
                                      isSubmitting = true;
                                    });

                                    try {
                                      await userService.activateSuspendUser(
                                        user["_id"],
                                      );

                                      if (!dialogContext.mounted) {
                                        return;
                                      }

                                      Navigator.of(dialogContext).pop(true);
                                    } catch (e) {
                                      if (!dialogContext.mounted) {
                                        return;
                                      }

                                      setDialogState(() {
                                        isSubmitting = false;
                                      });

                                      ScaffoldMessenger.maybeOf(
                                        dialogContext,
                                      )?.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Gagal mengaktifkan user: $e",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
            );
          },
        );
      },
    );

    // Dialog sudah benar-benar selesai ditutup
    if (result != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    try {
      final provider = context.read<UserManagementProvider>();

      await provider.getUsers();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text("User berhasil diaktifkan kembali"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            "User berhasil diaktifkan, tetapi gagal refresh data: $e",
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // ============================================================
  // NONAKTIF
  // ============================================================
  Future<void> showDeactivateDialog(dynamic user) async {
    try {
      await userService.deactivateUser(user["_id"]);

      if (!mounted) return;

      await context.read<UserManagementProvider>().getUsers();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text("Gagal menonaktifkan user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // AKTIFKAN USER
  // ============================================================
  Future<void> showActivateDialog(dynamic user) async {
    try {
      await userService.activateUser(user["_id"]);

      if (!mounted) return;

      await context.read<UserManagementProvider>().getUsers();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text("Gagal mengaktifkan user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserManagementProvider>();

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ========================================================
      // APP BAR
      // ========================================================
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
              "Semua User",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Builder(
          builder: (_) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.userList.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada user",
                  style: TextStyle(color: AuthTheme.subtitle),
                ),
              );
            }

            // ==================================================
            // FILTER USER
            // ==================================================
            final filteredUsers = provider.userList.where((user) {
              final query = searchQuery.toLowerCase();

              final name = (user["name"] ?? "").toString().toLowerCase();

              final email = (user["email"] ?? "").toString().toLowerCase();

              final phone = (user["phone"] ?? "").toString().toLowerCase();

              return name.contains(query) ||
                  email.contains(query) ||
                  phone.contains(query);
            }).toList();

            return Column(
              children: [
                // ==================================================
                // SEARCH
                // ==================================================
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Cari nama, email atau nomor HP...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: AuthTheme.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LIST
                // ==================================================
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,

                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),

                        decoration: BoxDecoration(
                          color: AuthTheme.cardBackground,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AuthTheme.border),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==================================================
                            // DATA USER
                            // ==================================================
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: AuthTheme.buttonGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      (user["name"] ?? "-")
                                              .toString()
                                              .isNotEmpty
                                          ? user["name"]
                                                .toString()
                                                .substring(0, 1)
                                                .toUpperCase()
                                          : "U",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 15),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                            // ==================================================
                            // OWNER USER
                            // ==================================================
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person_pin_circle,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Owner User",
                                        style: TextStyle(
                                          color: AuthTheme.subtitle,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    user["ownerId"]?["name"] ?? "-",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AuthTheme.blueGlow.withOpacity(
                                        .15,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      user["ownerId"]?["role"] ?? "-",
                                      style: const TextStyle(
                                        color: AuthTheme.blueGlow,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),

                            // ==================================================
                            // STATUS USER + MODULE
                            // ==================================================
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
                                    final date = DateTime.parse(
                                      expiredAt.toString(),
                                    );

                                    isExpired = date.isBefore(DateTime.now());

                                    expiredText = DateFormat(
                                      "dd MMMM yyyy",
                                    ).format(date);
                                  } catch (_) {
                                    isExpired = true;
                                    expiredText = "Belum diperpanjang";
                                  }
                                }

                                return Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // STATUS AKUN
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.verified_user,
                                            color: Colors.white54,
                                            size: 20,
                                          ),

                                          const SizedBox(width: 10),

                                          const Expanded(
                                            child: Text(
                                              "Status Akun",
                                              style: TextStyle(
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
                                              color: accountColor.withOpacity(
                                                .15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              accountText,
                                              style: TextStyle(
                                                color: accountColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const Divider(height: 25),

                                      // STATUS MODUL
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.workspace_premium,
                                            color: Colors.white54,
                                            size: 20,
                                          ),

                                          const SizedBox(width: 10),

                                          const Expanded(
                                            child: Text(
                                              "Status Modul",
                                              style: TextStyle(
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
                                                      .withOpacity(.15),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              isExpired ? "Expired" : "Aktif",
                                              style: TextStyle(
                                                color: isExpired
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: FontWeight.bold,
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

                                          Text(
                                            expiredText,
                                            style: const TextStyle(
                                              color: AuthTheme.subtitle,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // ==================================================
                            // BUTTON AREA
                            // ==================================================
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3,

                              children: [
                                // ==================================================
                                // EDIT
                                // ==================================================
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
                                          builder: (_) =>
                                              EditUserPage(user: user),
                                        ),
                                      );

                                      if (result == true) {
                                        if (!mounted) return;

                                        await context
                                            .read<UserManagementProvider>()
                                            .getUsers();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),

                                // ==================================================
                                // PERPANJANG
                                // ==================================================
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
                                        builder: (_) =>
                                            const ExtendModuleDialog(),
                                      );

                                      if (days == null) return;

                                      if (!mounted) return;

                                      await context
                                          .read<UserManagementProvider>()
                                          .extendModule(
                                            user["_id"],
                                            days,
                                            context.read<AuthProvider>(),
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.schedule,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Perpanjang",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),

                                // ==================================================
                                // PINDAH
                                // ==================================================
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
                                    ),
                                    label: const Text(
                                      "Pindah",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),

                                // ==================================================
                                // SUSPEND
                                // ==================================================
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
                                      if (!mounted) return;

                                      if (user["accountStatus"] ==
                                          "suspended") {
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
                                    ),
                                    label: Text(
                                      user["accountStatus"] == "suspended"
                                          ? "Aktifkan"
                                          : "Suspend",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                // ==================================================
                                // NONAKTIF
                                // ==================================================
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: user["isActive"] == true
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  onPressed: () async {
                                    if (!mounted) return;

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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
