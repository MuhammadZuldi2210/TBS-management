// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import reseller provider
import '../viewmodels/reseller_provider.dart';

// import auth provider
import '../../auth/viewmodels/auth_provider.dart';

class EditResellerPage extends StatefulWidget {
  // data reseller
  final Map<String, dynamic> reseller;

  const EditResellerPage({super.key, required this.reseller});

  @override
  State<EditResellerPage> createState() => _EditResellerPageState();
}

class _EditResellerPageState extends State<EditResellerPage> {
  // ==========================================================
  // CONTROLLER
  // ==========================================================

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.reseller["name"] ?? "");

    phoneController = TextEditingController(
      text: widget.reseller["phone"] ?? "",
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String resellerName =
        widget.reseller["name"]?.toString() ?? "Reseller";

    final String resellerEmail = widget.reseller["email"]?.toString() ?? "-";

    // ==========================================================
    // CEK ROLE LOGIN
    // RESET PASSWORD HANYA SUPER ADMIN
    // ==========================================================

    final String? currentRole = context.watch<AuthProvider>().role;

    final bool canResetPassword = currentRole == "super_admin";

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        titleSpacing: 4,

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 34),

            const SizedBox(width: 10),

            const Text(
              "Edit Reseller",
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // PROFILE HEADER
            // ==================================================
            _buildResellerHeader(
              resellerName: resellerName,
              resellerEmail: resellerEmail,
            ),

            const SizedBox(height: 28),

            // ==================================================
            // INFORMASI RESELLER
            // ==================================================
            const Text(
              "Informasi Reseller",
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Perbarui informasi dasar akun reseller.",
              style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
            ),

            const SizedBox(height: 15),

            _buildFormCard(),

            // ==================================================
            // KEAMANAN AKUN
            // HANYA SUPER ADMIN
            // ==================================================
            if (canResetPassword) ...[
              const SizedBox(height: 25),

              const Text(
                "Keamanan Akun",
                style: TextStyle(
                  color: AuthTheme.title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Kelola password akun reseller.",
                style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
              ),

              const SizedBox(height: 15),

              _buildSecurityCard(),

              const SizedBox(height: 25),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // RESELLER HEADER
  // ==========================================================

  Widget _buildResellerHeader({
    required String resellerName,
    required String resellerEmail,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AuthTheme.cardBackground,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: AuthTheme.border),

        boxShadow: [
          BoxShadow(
            color: AuthTheme.blueGlow.withValues(alpha: .10),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [
          // ==================================================
          // RESELLER ICON
          // ==================================================
          Container(
            width: 70,
            height: 70,

            decoration: BoxDecoration(
              gradient: AuthTheme.buttonGradient,

              borderRadius: BorderRadius.circular(22),

              boxShadow: [
                BoxShadow(
                  color: AuthTheme.blueGlow.withValues(alpha: .25),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: const Icon(
              Icons.store_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),

          const SizedBox(width: 16),

          // ==================================================
          // RESELLER INFO
          // ==================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Flexible(
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

                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: AuthTheme.blueGlow.withValues(alpha: .10),

                        borderRadius: BorderRadius.circular(20),

                        border: Border.all(
                          color: AuthTheme.blueGlow.withValues(alpha: .20),
                        ),
                      ),

                      child: const Text(
                        "RESELLER",
                        style: TextStyle(
                          color: AuthTheme.blueGlow,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: AuthTheme.subtitle,
                      size: 15,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        resellerEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: AuthTheme.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,

                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    const Text(
                      "Kelola informasi akun",
                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FORM CARD
  // ==========================================================

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AuthTheme.cardBackground,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AuthTheme.border),
      ),

      child: Column(
        children: [
          // ==================================================
          // NAMA
          // ==================================================
          _buildInput(
            controller: nameController,
            label: "Nama Reseller",
            hint: "Masukkan nama reseller",
            icon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // ==================================================
          // PHONE
          // ==================================================
          _buildInput(
            controller: phoneController,
            label: "Nomor Telepon",
            hint: "Masukkan nomor telepon",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),

          const SizedBox(height: 22),

          // ==================================================
          // SIMPAN
          // ==================================================
          _buildGradientButton(
            text: "Simpan Perubahan",
            icon: Icons.check_rounded,

            onPressed: () async {
              final provider = context.read<ResellerProvider>();

              final success = await provider.updateReseller(
                resellerId: widget.reseller["_id"].toString(),
                name: nameController.text,
                phone: phoneController.text,
              );

              if (success && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECURITY CARD
  // ==========================================================

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AuthTheme.cardBackground,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AuthTheme.border),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: AuthTheme.blueGlow.withValues(alpha: .10),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.security_rounded,
                  color: AuthTheme.blueGlow,
                  size: 24,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Password Reseller",
                      style: TextStyle(
                        color: AuthTheme.title,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Buat password baru untuk akun reseller.",
                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          // ==================================================
          // RESET PASSWORD
          // ==================================================
          _buildGradientButton(
            text: "Reset Password",
            icon: Icons.lock_reset_rounded,

            onPressed: () async {
              final String? newPassword = await _showResetPasswordDialog(
                context,
              );

              if (newPassword == null || newPassword.isEmpty) {
                return;
              }

              if (!context.mounted) {
                return;
              }

              final provider = context.read<ResellerProvider>();

              final result = await provider.resetPassword(
                resellerId: widget.reseller["_id"].toString(),
                newPassword: newPassword,
              );

              if (!context.mounted) {
                return;
              }

              if (result) {
                await _showResetPasswordSuccessDialog(context, newPassword);
              } else {
                _showErrorSnackBar(
                  context,
                  provider.errorMessage ?? "Gagal mereset password reseller",
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INPUT FIELD
  // ==========================================================

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: const TextStyle(
            color: AuthTheme.title,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: AuthTheme.inputFill,

            borderRadius: BorderRadius.circular(15),

            border: Border.all(color: AuthTheme.border),
          ),

          child: TextField(
            controller: controller,

            keyboardType: keyboardType,

            textInputAction: textInputAction,

            style: const TextStyle(color: AuthTheme.title, fontSize: 13),

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: const TextStyle(color: AuthTheme.hint, fontSize: 12),

              prefixIcon: Icon(icon, color: AuthTheme.blueGlow, size: 20),

              border: InputBorder.none,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // GRADIENT BUTTON
  // ==========================================================

  Widget _buildGradientButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,

      child: Container(
        decoration: BoxDecoration(
          gradient: AuthTheme.buttonGradient,

          borderRadius: BorderRadius.circular(15),

          boxShadow: [
            BoxShadow(
              color: AuthTheme.blueGlow.withValues(alpha: .18),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
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
              Icon(icon, color: Colors.white, size: 20),

              const SizedBox(width: 8),

              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
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
  // RESET PASSWORD DIALOG
  // ==========================================================

  Future<String?> _showResetPasswordDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,

      builder: (_) {
        return _ResetPasswordDialog(reseller: widget.reseller);
      },
    );
  }

  // ==========================================================
  // SUCCESS DIALOG
  // ==========================================================

  Future<void> _showResetPasswordSuccessDialog(
    BuildContext context,
    String newPassword,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (_) {
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
                  width: 65,
                  height: 65,

                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Password Berhasil Direset",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: AuthTheme.title,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Password reseller "
                  "${widget.reseller["name"] ?? "-"} "
                  "berhasil direset.",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: AuthTheme.subtitle,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "PASSWORD BARU",

                  style: TextStyle(
                    color: AuthTheme.subtitle,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),

                  decoration: BoxDecoration(
                    color: AuthTheme.blueGlow.withValues(alpha: .08),

                    borderRadius: BorderRadius.circular(13),

                    border: Border.all(
                      color: AuthTheme.blueGlow.withValues(alpha: .25),
                    ),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: AuthTheme.blueGlow,
                        size: 21,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          newPassword,

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: AuthTheme.title,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Berikan password baru ini kepada reseller.",

                  textAlign: TextAlign.center,

                  style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                ),

                const SizedBox(height: 22),

                _buildGradientButton(
                  text: "Selesai",
                  icon: Icons.check_rounded,

                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // ERROR SNACKBAR
  // ==========================================================

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),

        backgroundColor: Colors.red,

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ==========================================================
// RESET PASSWORD DIALOG
// ==========================================================

class _ResetPasswordDialog extends StatefulWidget {
  final Map<String, dynamic> reseller;

  const _ResetPasswordDialog({required this.reseller});

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  late final TextEditingController _passwordController;

  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();

    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();

    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // SUBMIT
  // ==========================================================

  void _submit() {
    final password = _passwordController.text.trim();

    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty) {
      _showError("Password baru wajib diisi.");

      return;
    }

    if (password.length < 6) {
      _showError("Password baru minimal 6 karakter.");

      return;
    }

    if (confirmPassword.isEmpty) {
      _showError("Konfirmasi password wajib diisi.");

      return;
    }

    if (password != confirmPassword) {
      _showError("Password dan konfirmasi password tidak sama.");

      return;
    }

    Navigator.pop(context, password);
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),

        backgroundColor: Colors.red,

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
                      Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Reset Password",

                          style: TextStyle(
                            color: AuthTheme.title,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Buat password baru untuk reseller ini",

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

                    icon: const Icon(
                      Icons.close_rounded,
                      color: AuthTheme.subtitle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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

                    SizedBox(width: 9),

                    Expanded(
                      child: Text(
                        "Super Admin akan membuat password baru untuk akun reseller ini.",

                        style: TextStyle(
                          color: AuthTheme.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // PASSWORD BARU
              // ==================================================
              const Text(
                "Password Baru",

                style: TextStyle(
                  color: AuthTheme.title,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              _buildPasswordField(
                controller: _passwordController,

                hint: "Masukkan password baru",

                obscureText: _obscurePassword,

                onToggle: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },

                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 15),

              // ==================================================
              // KONFIRMASI
              // ==================================================
              const Text(
                "Konfirmasi Password",

                style: TextStyle(
                  color: AuthTheme.title,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              _buildPasswordField(
                controller: _confirmPasswordController,

                hint: "Masukkan ulang password",

                obscureText: _obscureConfirmPassword,

                onToggle: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },

                textInputAction: TextInputAction.done,

                onSubmitted: (_) {
                  _submit();
                },
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

                        onPressed: _submit,

                        child: const Text(
                          "Reset Password",

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

  // ==========================================================
  // PASSWORD FIELD
  // ==========================================================

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
    required TextInputAction textInputAction,
    void Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AuthTheme.inputFill,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: AuthTheme.border),
      ),

      child: TextField(
        controller: controller,

        obscureText: obscureText,

        textInputAction: textInputAction,

        onSubmitted: onSubmitted,

        style: const TextStyle(color: AuthTheme.title, fontSize: 13),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(color: AuthTheme.hint, fontSize: 12),

          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: AuthTheme.blueGlow,
            size: 20,
          ),

          suffixIcon: IconButton(
            onPressed: onToggle,

            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,

              color: AuthTheme.subtitle,
              size: 20,
            ),
          ),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
