// import flutter material
import 'package:flutter/material.dart';

// import dio client
import '../../../core/api/dio_client.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import edit user
import '../../user_management/views/edit_user_page.dart';

// import intl
import 'package:intl/intl.dart';

// import admin service
import '../../admin_management/services/admin_service.dart';

// import user service
import '../../user_management/services/user_management_service.dart';

// import extend module dialog
import '../../user_management/widgets/extend_module_dialog.dart';

class AdminResellerUserPage extends StatefulWidget {
  // id reseller
  final String resellerId;

  const AdminResellerUserPage({super.key, required this.resellerId});

  @override
  State<AdminResellerUserPage> createState() => _AdminResellerUsersPageState();
}

class _AdminResellerUsersPageState extends State<AdminResellerUserPage> {
  // service admin
  final AdminService adminService = AdminService();

  // service user
  final UserManagementService userService = UserManagementService();

  // daftar user
  List<dynamic> users = [];

  // loading
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getUsers();
  }

  // ============================================================
  // GET USERS
  // ============================================================

  Future<void> getUsers() async {
    try {
      final response = await DioClient.dio.get(
        "/users/reseller/${widget.resellerId}/users",
      );

      final data = response.data["data"];

      if (!mounted) return;

      setState(() {
        users = data is List ? List<dynamic>.from(data) : [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("GET RESELLER USERS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================================================
  // PINDAH USER
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
            builder: (context, setDialogState) {
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
                      // ==================================================
                      // HEADER
                      // ==================================================
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

                      // ==================================================
                      // USER INFO
                      // ==================================================
                      _userInfoCard(
                        user,
                        icon: Icons.person,
                        color: AuthTheme.blueGlow,
                        title: "User yang dipindahkan",
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

                      // ==================================================
                      // DROPDOWN OWNER
                      // ==================================================
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
                                    Icon(
                                      owner["role"] == "reseller"
                                          ? Icons.storefront
                                          : Icons.admin_panel_settings,
                                      color: AuthTheme.blueGlow,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        owner["name"] ?? "-",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AuthTheme.title,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedOwner = value;
                              });
                            },
                          ),
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
                                side: const BorderSide(color: AuthTheme.border),
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
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
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

                                          if (!dialogContext.mounted) {
                                            return;
                                          }

                                          Navigator.of(dialogContext).pop();

                                          if (!mounted) return;

                                          await getUsers();

                                          if (!mounted) return;

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "User berhasil dipindahkan",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                        } catch (e) {
                                          debugPrint("TRANSFER USER ERROR: $e");

                                          if (!dialogContext.mounted) {
                                            return;
                                          }

                                          Navigator.of(dialogContext).pop();

                                          if (!mounted) return;

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Gagal memindahkan user: $e",
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                        }
                                      },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.swap_horiz, size: 18),
                                    SizedBox(width: 7),
                                    Text(
                                      "Pindahkan",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
      debugPrint("TRANSFER DIALOG ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
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

    try {
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
                  child: SingleChildScrollView(
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
                              onPressed: isSubmitting
                                  ? null
                                  : () {
                                      Navigator.of(dialogContext).pop(false);
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
                        // USER INFO
                        // ==================================================
                        _userInfoCard(
                          user,
                          icon: Icons.block,
                          color: Colors.orange,
                          title: "User yang akan disuspend",
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

                        // ==================================================
                        // REASON
                        // ==================================================
                        TextField(
                          controller: reasonController,
                          maxLines: 4,
                          enabled: !isSubmitting,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
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
                              child: Icon(
                                Icons.edit_note,
                                color: Colors.orange,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 45,
                              minHeight: 45,
                            ),
                            contentPadding: const EdgeInsets.all(14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AuthTheme.border,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                              ),
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
                                  "User yang disuspend tidak dapat "
                                  "menggunakan akun sampai suspend "
                                  "diaktifkan kembali.",
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
                                  side: const BorderSide(
                                    color: AuthTheme.border,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
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
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                onPressed: isSubmitting
                                    ? null
                                    : () async {
                                        final reason = reasonController.text
                                            .trim();

                                        // ==================================
                                        // VALIDASI
                                        // ==================================

                                        if (reason.isEmpty) {
                                          if (!dialogContext.mounted) {
                                            return;
                                          }

                                          ScaffoldMessenger.maybeOf(
                                            dialogContext,
                                          )?.hideCurrentSnackBar();

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

                                        // ==================================
                                        // LOADING
                                        // ==================================

                                        setDialogState(() {
                                          isSubmitting = true;
                                        });

                                        try {
                                          // ==================================
                                          // API SUSPEND
                                          // ==================================

                                          await userService.suspendUser(
                                            user["_id"],
                                            reason,
                                          );

                                          // ==================================
                                          // API BERHASIL
                                          // TUTUP DIALOG SAJA
                                          // ==================================

                                          if (!dialogContext.mounted) {
                                            return;
                                          }

                                          Navigator.of(dialogContext).pop(true);
                                        } catch (e) {
                                          debugPrint("SUSPEND USER ERROR: $e");

                                          if (!dialogContext.mounted) {
                                            return;
                                          }

                                          setDialogState(() {
                                            isSubmitting = false;
                                          });

                                          ScaffoldMessenger.maybeOf(
                                            dialogContext,
                                          )?.hideCurrentSnackBar();

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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                ),
              );
            },
          );
        },
      );

      // ============================================================
      // DIALOG SUDAH TERTUTUP
      // ============================================================

      if (result != true) {
        return;
      }

      if (!mounted) {
        return;
      }

      // Refresh dari PAGE context
      await getUsers();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("User berhasil disuspend"),
            backgroundColor: Colors.orange,
          ),
        );
    } finally {
      reasonController.dispose();
    }
  }

  // ============================================================
  // DIALOG AKTIFKAN SUSPEND
  // ============================================================

  Future<void> showActivateSuspendDialog(dynamic user) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _ConfirmationDialog(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          title: "Aktifkan User",
          message:
              "Apakah kamu yakin ingin mengaktifkan kembali "
              "${user["name"] ?? "user"}?",
          info:
              "Suspend user akan dihapus dan user dapat "
              "menggunakan akun kembali.",
          confirmText: "Aktifkan",
          confirmColor: Colors.green,
          onConfirm: () async {
            await userService.activateSuspendUser(user["_id"]);
          },
        );
      },
    );

    if (result != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    await getUsers();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text("User berhasil diaktifkan kembali"),
          backgroundColor: Colors.green,
        ),
      );
  }

  // ============================================================
  // DIALOG AKTIFKAN USER
  // ============================================================

  Future<void> showActivateDialog(dynamic user) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
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
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
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
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "Apakah kamu yakin ingin mengaktifkan kembali "
                  "${user["name"] ?? "user"}?",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "User dapat menggunakan akun kembali "
                          "setelah diaktifkan.",
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
                          side: const BorderSide(color: AuthTheme.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await userService.activateUser(user["_id"]);

                            if (!dialogContext.mounted) {
                              return;
                            }

                            Navigator.pop(dialogContext);

                            if (!mounted) {
                              return;
                            }

                            await getUsers();

                            if (!mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User berhasil diaktifkan"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            debugPrint("ACTIVATE USER ERROR: $e");

                            if (!dialogContext.mounted) {
                              return;
                            }

                            ScaffoldMessenger.maybeOf(
                              dialogContext,
                            )?.showSnackBar(
                              SnackBar(
                                content: Text("Gagal mengaktifkan user: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 18),
                            SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                "Aktifkan",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
  }

  // ============================================================
  // DIALOG NONAKTIFKAN USER
  // ============================================================

  Future<void> showDeactivateDialog(dynamic user) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
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
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_off,
                    color: Colors.red,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Nonaktifkan User",
                  style: TextStyle(
                    color: AuthTheme.title,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "Apakah kamu yakin ingin menonaktifkan "
                  "${user["name"] ?? "user"}?",
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
                    color: Colors.red.withValues(alpha: .07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: .18),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "User yang dinonaktifkan tidak dapat "
                          "menggunakan akun sampai diaktifkan kembali.",
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
                          side: const BorderSide(color: AuthTheme.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await userService.deactivateUser(user["_id"]);

                            if (!dialogContext.mounted) {
                              return;
                            }

                            Navigator.pop(dialogContext);

                            if (!mounted) {
                              return;
                            }

                            await getUsers();

                            if (!mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User berhasil dinonaktifkan"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } catch (e) {
                            debugPrint("DEACTIVATE USER ERROR: $e");

                            if (!dialogContext.mounted) {
                              return;
                            }

                            ScaffoldMessenger.maybeOf(
                              dialogContext,
                            )?.showSnackBar(
                              SnackBar(
                                content: Text("Gagal menonaktifkan user: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off, size: 18),
                            SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                "Nonaktifkan",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
  }

  // ============================================================
  // USER INFO CARD
  // ============================================================

  Widget _userInfoCard(
    dynamic user, {
    required IconData icon,
    required Color color,
    required String title,
  }) {
    final name = user["name"]?.toString() ?? "-";
    final email = user["email"]?.toString() ?? "-";

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
              color: color.withValues(alpha: .15),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, color: color, size: 20)),
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
                  name,
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ==========================================================
      // APPBAR
      // ==========================================================
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
              "Detail user reseller",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Builder(
          builder: (_) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (users.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada user",
                  style: TextStyle(color: AuthTheme.subtitle),
                ),
              );
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

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
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AuthTheme.blueGlow,
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

                      // ==================================================
                      // STATUS USER
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
                              final date = DateTime.parse(expiredAt.toString());

                              isExpired = date.isBefore(DateTime.now());

                              expiredText = DateFormat(
                                "dd MMMM yyyy",
                              ).format(date);
                            } catch (_) {
                              expiredText = "-";
                            }
                          }

                          return Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .08),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // STATUS AKUN
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

                                // STATUS MODUL
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

                      // ==================================================
                      // TOMBOL AKSI
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
                                    builder: (_) => EditUserPage(user: user),
                                  ),
                                );

                                if (result == true && mounted) {
                                  await getUsers();
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
                                final result = await showDialog<int>(
                                  context: context,
                                  builder: (_) => const ExtendModuleDialog(),
                                );

                                if (result == null) {
                                  return;
                                }

                                try {
                                  await userService.extendModule(
                                    user["_id"],
                                    result,
                                  );

                                  if (!mounted) {
                                    return;
                                  }

                                  await getUsers();

                                  if (!mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Modul berhasil "
                                        "diperpanjang "
                                        "$result hari",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Gagal memperpanjang "
                                        "modul: $e",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
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

                          // ==================================================
                          // PINDAH USER
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
                                size: 18,
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

                          // ==================================================
                          // NONAKTIF / AKTIFKAN USER
                          // ==================================================
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user["isActive"] == true
                                  ? Colors.red
                                  : Colors.green,
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
// CONFIRMATION DIALOG
// ================================================================

class _ConfirmationDialog extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String info;
  final String confirmText;
  final Color confirmColor;
  final Future Function() onConfirm;

  const _ConfirmationDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.info,
    required this.confirmText,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  State<_ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<_ConfirmationDialog> {
  bool isSubmitting = false;

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (isSubmitting) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await widget.onConfirm();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint("CONFIRM DIALOG ERROR: $e");

      if (!mounted) {
        return;
      }

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
        );
    }
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ======================================================
            // ICON
            // ======================================================
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 32),
            ),

            const SizedBox(height: 16),

            // ======================================================
            // TITLE
            // ======================================================
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AuthTheme.title,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // ======================================================
            // MESSAGE
            // ======================================================
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AuthTheme.subtitle,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            // ======================================================
            // INFO
            // ======================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.iconColor.withValues(alpha: .18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: widget.iconColor, size: 18),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      widget.info,
                      style: const TextStyle(
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

            // ======================================================
            // BUTTON
            // ======================================================
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AuthTheme.subtitle,
                      side: const BorderSide(color: AuthTheme.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: isSubmitting
                        ? null
                        : () {
                            Navigator.of(context).pop(false);
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
                      backgroundColor: widget.confirmColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: isSubmitting ? null : _submit,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.confirmText,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
