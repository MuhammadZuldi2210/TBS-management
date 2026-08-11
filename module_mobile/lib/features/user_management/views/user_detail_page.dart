// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// Import auth provider
import '../../auth/viewmodels/auth_provider.dart';

// import intl
import 'package:intl/intl.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import provider user
import '../viewmodels/user_management_provider.dart';

// import service user
import '../services/user_management_service.dart';

// import edit user
import 'edit_user_page.dart';

// import extend dialog
import '../widgets/extend_module_dialog.dart';

// import admin service
import '../../admin_management/services/admin_service.dart';

// Import dashboard provider
import '../../dashboard/admin_user/viewmodels/dashboard_provider.dart';

class UserDetailPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final UserManagementService userService = UserManagementService();
  final AdminService adminService = AdminService();

  Map<String, dynamic>? currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = widget.user;
  }

  // ============================================================
  // REFRESH DATA USER
  // ============================================================
  Future<void> refreshUser() async {
    final provider = Provider.of<UserManagementProvider>(
      context,
      listen: false,
    );

    await provider.getMyUsers();

    if (!mounted) return;

    try {
      final updatedUser = provider.userList.firstWhere(
        (item) => item["_id"] == widget.user["_id"],
      );

      setState(() {
        currentUser = updatedUser;
      });
    } catch (e) {
      debugPrint("User tidak ditemukan setelah refresh: $e");
    }
  }

  // ============================================================
  // DIALOG PINDAH USER
  // ============================================================
  Future<void> showTransferDialog() async {
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
                  child: SingleChildScrollView(
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

                        // ==========================
                        // INFO USER
                        // ==========================
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
                                    currentUser?["name"] != null &&
                                            currentUser!["name"]
                                                .toString()
                                                .isNotEmpty
                                        ? currentUser!["name"][0]
                                              .toString()
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
                                      currentUser?["name"] ?? "-",
                                      style: const TextStyle(
                                        color: AuthTheme.title,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      currentUser?["email"] ?? "-",
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

                        // ==========================
                        // DROPDOWN
                        // ==========================
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

                        // ==========================
                        // SELECTED OWNER INFO
                        // ==========================
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
                                    "User akan dipindahkan ke "
                                    "${selectedOwnerData["name"] ?? "-"}",
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
                                              currentUser!["_id"],
                                              selectedOwner!,
                                            );

                                            if (!mounted) {
                                              return;
                                            }

                                            Navigator.pop(dialogContext);

                                            if (!mounted) {
                                              return;
                                            }

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "User berhasil dipindahkan",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            Navigator.pop(context, true);
                                          } catch (e) {
                                            if (!mounted) {
                                              return;
                                            }

                                            ScaffoldMessenger.of(
                                              context,
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
  Future<void> showSuspendDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return _SuspendUserDialog(
          userName: currentUser?["name"] ?? "User",
          userEmail: currentUser?["email"] ?? "-",
          onConfirm: (reason) async {
            try {
              await userService.suspendUser(currentUser!["_id"], reason);

              if (!mounted) return;

              Navigator.pop(dialogContext);

              await refreshUser();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User berhasil disuspend"),
                  backgroundColor: Colors.orange,
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gagal suspend user: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  // ============================================================
  // DIALOG AKTIFKAN SUSPEND
  // ============================================================
  Future<void> showActivateSuspendDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return _confirmationDialog(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          title: "Aktifkan User",
          description:
              "Apakah kamu yakin ingin mengaktifkan kembali "
              "${currentUser?["name"] ?? "user"}?",
          infoText:
              "Suspend user akan dihapus dan user dapat "
              "menggunakan akun kembali.",
          infoIcon: Icons.info_outline,
          buttonText: "Aktifkan",
          buttonIcon: Icons.check_circle,
          buttonColor: Colors.green,
          onConfirm: () async {
            try {
              await userService.activateSuspendUser(currentUser!["_id"]);

              if (!mounted) return;

              Navigator.pop(dialogContext);

              await refreshUser();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User berhasil diaktifkan kembali"),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gagal mengaktifkan user: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  // ============================================================
  // DIALOG NONAKTIFKAN
  // ============================================================
  Future<void> showDeactivateDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return _confirmationDialog(
          icon: Icons.person_off,
          iconColor: Colors.red,
          title: "Nonaktifkan User",
          description:
              "Apakah kamu yakin ingin menonaktifkan "
              "${currentUser?["name"] ?? "user"}?",
          infoText:
              "User yang dinonaktifkan tidak dapat menggunakan "
              "akun sampai diaktifkan kembali.",
          infoIcon: Icons.warning_amber_rounded,
          buttonText: "Nonaktifkan",
          buttonIcon: Icons.person_off,
          buttonColor: Colors.red,
          onConfirm: () async {
            try {
              await userService.deactivateUser(currentUser!["_id"]);

              if (!mounted) return;

              Navigator.pop(dialogContext);

              await refreshUser();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User berhasil dinonaktifkan"),
                  backgroundColor: Colors.red,
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gagal menonaktifkan user: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  // ============================================================
  // DIALOG AKTIFKAN USER
  // ============================================================
  Future<void> showActivateDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return _confirmationDialog(
          icon: Icons.person,
          iconColor: Colors.green,
          title: "Aktifkan User",
          description:
              "Apakah kamu yakin ingin mengaktifkan kembali "
              "${currentUser?["name"] ?? "user"}?",
          infoText:
              "User dapat menggunakan akun kembali setelah "
              "diaktifkan.",
          infoIcon: Icons.info_outline,
          buttonText: "Aktifkan",
          buttonIcon: Icons.person,
          buttonColor: Colors.green,
          onConfirm: () async {
            try {
              await userService.activateUser(currentUser!["_id"]);

              if (!mounted) return;

              Navigator.pop(dialogContext);

              await refreshUser();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User berhasil diaktifkan"),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gagal mengaktifkan user: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  // ============================================================
  // GENERIC CONFIRMATION DIALOG
  // ============================================================
  Widget _confirmationDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String infoText,
    required IconData infoIcon,
    required String buttonText,
    required IconData buttonIcon,
    required Color buttonColor,
    required Future Function() onConfirm,
  }) {
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
            children: [
              // ==========================
              // ICON
              // ==========================
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: buttonColor.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),

              const SizedBox(height: 16),

              // ==========================
              // TITLE
              // ==========================
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AuthTheme.title,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // ==========================
              // DESCRIPTION
              // ==========================
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AuthTheme.subtitle,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              // ==========================
              // INFO
              // ==========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: buttonColor.withValues(alpha: .07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: buttonColor.withValues(alpha: .18)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(infoIcon, color: iconColor, size: 18),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        infoText,
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

              // ==========================
              // BUTTON
              // ==========================
              Row(
                children: [
                  Expanded(child: _dialogCancelButton(context)),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      onPressed: () async {
                        await onConfirm();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(buttonIcon, size: 18),

                          const SizedBox(width: 7),

                          Flexible(
                            child: Text(
                              buttonText,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
  }

  // ============================================================
  // BUTTON BATAL DIALOG
  // ============================================================
  Widget _dialogCancelButton(BuildContext dialogContext) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AuthTheme.subtitle,
        side: BorderSide(color: AuthTheme.border),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      onPressed: () {
        Navigator.pop(dialogContext);
      },
      child: const Text("Batal", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: AuthTheme.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = currentUser!;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final isSuperAdmin = auth.role == "super_admin";
    final isAdmin = auth.role == "admin_user";
    final isReseller = auth.role == "reseller";

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
              "Detail User",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: AuthTheme.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AuthTheme.border),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================
              // PROFILE USER
              // ==========================
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
                            ? user["name"][0].toString().toUpperCase()
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AuthTheme.title,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          user["email"] ?? "-",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AuthTheme.subtitle),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          user["phone"] ?? "-",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AuthTheme.subtitle),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ==========================
              // STATUS CARD
              // ==========================
              _statusCard(user),

              const SizedBox(height: 15),

              // ==========================
              // ACTION BUTTON
              // ==========================
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,

                children: [
                  // ==========================
                  // EDIT
                  // ==========================
                  _actionButton(
                    icon: Icons.edit,
                    text: "Edit",
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditUserPage(user: user),
                        ),
                      );

                      if (result == true) {
                        await refreshUser();
                      }
                    },
                  ),

                  // ==========================
                  // PERPANJANG
                  // ==========================
                  _actionButton(
                    icon: Icons.schedule,
                    text: "Perpanjang",
                    onTap: () async {
                      final days = await showDialog<int>(
                        context: context,
                        builder: (_) => const ExtendModuleDialog(),
                      );

                      if (days == null) return;

                      if (!mounted) return;

                      final userProvider = Provider.of<UserManagementProvider>(
                        context,
                        listen: false,
                      );

                      // ==========================================
                      // PERPANJANG MODUL
                      // ==========================================
                      final success = await userProvider.extendModule(
                        user["_id"],
                        days,
                        context.read<AuthProvider>(),
                      );

                      if (!mounted) return;

                      // ==========================================
                      // JIKA GAGAL
                      // ==========================================
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              userProvider.errorMessage ??
                                  "Gagal memperpanjang modul",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );

                        return;
                      }

                      // ==========================================
                      // REFRESH USER DETAIL
                      // ==========================================
                      await refreshUser();

                      if (!mounted) return;

                      // ==========================================
                      // REFRESH DASHBOARD
                      // ==========================================
                      await context
                          .read<AdminDashboardProvider>()
                          .getDashboardStats();

                      if (!mounted) return;

                      // ==========================================
                      // BERHASIL
                      // ==========================================
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Modul diperpanjang $days hari"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),

                  // ==========================
                  // PINDAH
                  // HANYA SUPER ADMIN
                  // ==========================
                  if (isSuperAdmin)
                    _actionButton(
                      icon: Icons.swap_horiz,
                      text: "Pindah",
                      onTap: () async {
                        await showTransferDialog();
                      },
                    ),

                  // ==========================
                  // SUSPEND
                  // ==========================
                  if (isSuperAdmin || isAdmin || isReseller)
                    _actionButton(
                      icon: user["accountStatus"] == "suspended"
                          ? Icons.check_circle
                          : Icons.block,

                      text: user["accountStatus"] == "suspended"
                          ? "Aktifkan"
                          : "Suspend",

                      onTap: () async {
                        if (currentUser?["accountStatus"] == "suspended") {
                          await showActivateSuspendDialog();
                        } else {
                          await showSuspendDialog();
                        }
                      },
                    ),

                  // ==========================
                  // NONAKTIF / AKTIFKAN
                  // ==========================
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: user["isActive"] == true
                          ? Colors.red
                          : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    icon: Icon(
                      user["isActive"] == true
                          ? Icons.person_off
                          : Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),

                    label: Text(
                      user["isActive"] == true ? "Nonaktif" : "Aktifkan",
                      style: const TextStyle(color: Colors.white),
                    ),

                    onPressed: () {
                      if (currentUser?["isActive"] == true) {
                        showDeactivateDialog();
                      } else {
                        showActivateDialog();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS CARD
  // ============================================================
  Widget _statusCard(dynamic user) {
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

        expiredText = DateFormat("dd MMMM yyyy").format(date);
      } catch (e) {
        debugPrint("Gagal parse moduleExpiredAt: $e");
      }
    }

    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: Column(
        children: [
          // ==========================
          // STATUS AKUN
          // ==========================
          Row(
            children: [
              Icon(Icons.verified_user, color: accountColor, size: 20),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "Status Akun",
                  style: TextStyle(color: AuthTheme.subtitle),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: accountColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(30),
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

          // ==========================
          // STATUS MODUL
          // ==========================
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: isExpired ? Colors.red : Colors.green,
                size: 20,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "Status Modul",
                  style: TextStyle(color: AuthTheme.subtitle),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: (isExpired ? Colors.red : Colors.green).withOpacity(
                    .15,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  isExpired ? "Expired" : "Aktif",
                  style: TextStyle(
                    color: isExpired ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ==========================
          // TANGGAL EXPIRED
          // ==========================
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.white54, size: 18),

              const SizedBox(width: 10),

              Text(
                expiredText,
                style: const TextStyle(color: AuthTheme.subtitle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================
  Widget _actionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: AuthTheme.buttonGradient,
        borderRadius: BorderRadius.circular(12),
      ),

      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: onTap,

        icon: Icon(icon, color: Colors.white, size: 18),

        label: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// ============================================================
// SUSPEND USER DIALOG
// ============================================================
class _SuspendUserDialog extends StatefulWidget {
  final String userName;
  final String userEmail;

  final Future<void> Function(String reason) onConfirm;

  const _SuspendUserDialog({
    required this.userName,
    required this.userEmail,
    required this.onConfirm,
  });

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

  // ============================================================
  // SUBMIT
  // ============================================================
  Future<void> _submit() async {
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
      await widget.onConfirm(reason);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================
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
              // ==========================
              // HEADER
              // ==========================
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

              // ==========================
              // USER INFO
              // ==========================
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
                          widget.userName.isNotEmpty
                              ? widget.userName[0].toUpperCase()
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
                            widget.userName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AuthTheme.title,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            widget.userEmail,
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

              // ==========================
              // LABEL
              // ==========================
              const Text(
                "Alasan Suspend",
                style: TextStyle(
                  color: AuthTheme.title,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ==========================
              // TEXT FIELD
              // ==========================
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

              // ==========================
              // WARNING
              // ==========================
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
                        "User yang disuspend tidak dapat menggunakan "
                        "akun sampai suspend diaktifkan kembali.",
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

                      onPressed: isLoading ? null : _submit,

                      child: isLoading
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
