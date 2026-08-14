// import flutter
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// dio client
import '../../../core/api/dio_client.dart';

// auth theme
import '../../../core/theme/auth_theme.dart';

// auth provider
import '../../auth/viewmodels/auth_provider.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user["name"] ?? "");

    emailController = TextEditingController(text: widget.user["email"] ?? "");

    phoneController = TextEditingController(text: widget.user["phone"] ?? "");
  }

  // ==========================
  // UPDATE USER
  // ==========================

  Future updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      await DioClient.dio.put(
        "/users/${widget.user["_id"]}",
        data: {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data user berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  // ==========================
  // INPUT DECORATION
  // ==========================

  InputDecoration _inputDecoration({
    required IconData icon,
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AuthTheme.blueGlow),

      labelText: label,

      labelStyle: const TextStyle(color: AuthTheme.subtitle),

      hintText: hint,

      hintStyle: const TextStyle(color: AuthTheme.hint),

      filled: true,

      fillColor: AuthTheme.inputFill,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AuthTheme.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AuthTheme.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AuthTheme.blueGlow, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.user["name"] ?? "User";

    // ==========================================================
    // CEK ROLE LOGIN
    // ==========================================================

    final authProvider = context.read<AuthProvider>();

    final bool isSuperAdmin = authProvider.role == "super_admin";

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ==========================
      // APP BAR
      // ==========================
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
              "Edit User",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ==========================
      // BODY
      // ==========================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================
              // HEADER
              // ==========================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  gradient: AuthTheme.buttonGradient,

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: AuthTheme.blueGlow.withValues(alpha: .20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,

                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .15),

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white.withValues(alpha: .25),
                        ),
                      ),

                      child: Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : "U",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
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
                          const Text(
                            "Edit Data User",

                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            userName,

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            widget.user["email"] ?? "-",

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==========================
              // TITLE
              // ==========================
              const Text(
                "Informasi User",

                style: TextStyle(
                  color: AuthTheme.title,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Perbarui informasi user di bawah ini.",

                style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
              ),

              const SizedBox(height: 20),

              // ==========================
              // NAMA
              // ==========================
              TextFormField(
                controller: nameController,

                style: const TextStyle(color: AuthTheme.title),

                textInputAction: TextInputAction.next,

                decoration: _inputDecoration(
                  icon: Icons.person_outline,
                  label: "Nama",
                  hint: "Masukkan nama user",
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama wajib diisi";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==========================
              // EMAIL
              // ==========================
              TextFormField(
                controller: emailController,

                keyboardType: TextInputType.emailAddress,

                textInputAction: TextInputAction.next,

                style: const TextStyle(color: AuthTheme.title),

                decoration: _inputDecoration(
                  icon: Icons.email_outlined,
                  label: "Email",
                  hint: "Masukkan email user",
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email wajib diisi";
                  }

                  if (!value.contains("@")) {
                    return "Format email tidak valid";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==========================
              // PHONE
              // ==========================
              TextFormField(
                controller: phoneController,

                keyboardType: TextInputType.phone,

                textInputAction: TextInputAction.done,

                style: const TextStyle(color: AuthTheme.title),

                decoration: _inputDecoration(
                  icon: Icons.phone_outlined,
                  label: "Nomor HP",
                  hint: "Masukkan nomor HP",
                ),
              ),

              const SizedBox(height: 30),

              // ==========================
              // BUTTON SIMPAN
              // ==========================
              SizedBox(
                width: double.infinity,

                height: 52,

                child: Container(
                  decoration: BoxDecoration(
                    gradient: AuthTheme.buttonGradient,

                    borderRadius: BorderRadius.circular(15),

                    boxShadow: [
                      BoxShadow(
                        color: AuthTheme.blueGlow.withValues(alpha: .20),

                        blurRadius: 15,

                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: ElevatedButton(
                    onPressed: isLoading ? null : updateUser,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,

                      disabledBackgroundColor: Colors.transparent,

                      shadowColor: Colors.transparent,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,

                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,

                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                Icons.save_outlined,
                                color: Colors.white,
                                size: 20,
                              ),

                              SizedBox(width: 10),

                              Text(
                                "Simpan Perubahan",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              // ==================================================
              // RESET PASSWORD
              // HANYA MUNCUL UNTUK SUPER ADMIN
              // ==================================================
              if (isSuperAdmin) ...[
                const SizedBox(height: 28),

                const Text(
                  "Keamanan Akun",

                  style: TextStyle(
                    color: AuthTheme.title,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Kelola password akun user.",

                  style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
                ),

                const SizedBox(height: 15),

                _buildSecurityCard(),
              ],

              const SizedBox(height: 12),
            ],
          ),
        ),
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
                      "Password User",

                      style: TextStyle(
                        color: AuthTheme.title,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Buat password baru untuk akun user.",

                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

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

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Reset password user siap digunakan."),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
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
        return _ResetPasswordDialog(user: widget.user);
      },
    );
  }

  // ==========================================================
  // INPUT BUTTON
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
}

// ==========================================================
// RESET PASSWORD DIALOG
// ==========================================================

class _ResetPasswordDialog extends StatefulWidget {
  final Map<String, dynamic> user;

  const _ResetPasswordDialog({required this.user});

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
        ),

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // ==========================
              // HEADER DIALOG
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
                      Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Text(
                      "Reset Password",

                      style: TextStyle(
                        color: AuthTheme.title,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
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

              const Text(
                "Buat password baru untuk user ini.",

                style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
              ),

              const SizedBox(height: 20),

              // ==========================
              // PASSWORD BARU
              // ==========================
              TextField(
                controller: _passwordController,

                obscureText: _obscurePassword,

                style: const TextStyle(color: AuthTheme.title),

                decoration: InputDecoration(
                  hintText: "Password baru",

                  filled: true,

                  fillColor: AuthTheme.inputFill,

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AuthTheme.blueGlow,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },

                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,

                      color: AuthTheme.subtitle,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ==========================
              // KONFIRMASI PASSWORD
              // ==========================
              TextField(
                controller: _confirmPasswordController,

                obscureText: _obscureConfirmPassword,

                style: const TextStyle(color: AuthTheme.title),

                onSubmitted: (_) {
                  _submit();
                },

                decoration: InputDecoration(
                  hintText: "Konfirmasi password",

                  filled: true,

                  fillColor: AuthTheme.inputFill,

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AuthTheme.blueGlow,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },

                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,

                      color: AuthTheme.subtitle,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ==========================
              // BUTTON DIALOG
              // ==========================
              Row(
                children: [
                  // BATAL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      style: OutlinedButton.styleFrom(
                        foregroundColor: AuthTheme.subtitle,

                        side: BorderSide(color: AuthTheme.border),

                        padding: const EdgeInsets.symmetric(vertical: 14),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text("Batal"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // RESET PASSWORD
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AuthTheme.buttonGradient,

                        borderRadius: BorderRadius.circular(12),

                        boxShadow: [
                          BoxShadow(
                            color: AuthTheme.blueGlow.withValues(alpha: .18),

                            blurRadius: 10,

                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: ElevatedButton(
                        onPressed: _submit,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,

                          shadowColor: Colors.transparent,

                          padding: const EdgeInsets.symmetric(vertical: 14),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

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
}
