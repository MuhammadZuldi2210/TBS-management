// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import profile provider
import '../viewmodels/profile_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // controller password
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // show hide password
  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    // hapus controller
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ambil provider
    final provider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      // background
      backgroundColor: AuthTheme.background,

      // appbar
      appBar: AppBar(
        backgroundColor: AuthTheme.background,

        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AuthTheme.title),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 35),

            const SizedBox(width: 10),

            const Text(
              "Ubah Password",
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: AuthTheme.cardBackground,

            borderRadius: BorderRadius.circular(22),

            border: Border.all(color: AuthTheme.border),
          ),

          child: Column(
            children: [
              // password lama
              _passwordField(
                controller: oldPasswordController,

                hint: "Password Lama",

                obscure: obscureOld,

                icon: Icons.lock_outline,

                onTap: () {
                  setState(() {
                    obscureOld = !obscureOld;
                  });
                },
              ),

              const SizedBox(height: 15),

              // password baru
              _passwordField(
                controller: newPasswordController,

                hint: "Password Baru",

                obscure: obscureNew,

                icon: Icons.lock,

                onTap: () {
                  setState(() {
                    obscureNew = !obscureNew;
                  });
                },
              ),

              const SizedBox(height: 15),

              // konfirmasi password
              _passwordField(
                controller: confirmPasswordController,

                hint: "Konfirmasi Password",

                obscure: obscureConfirm,

                icon: Icons.lock_reset,

                onTap: () {
                  setState(() {
                    obscureConfirm = !obscureConfirm;
                  });
                },
              ),

              const SizedBox(height: 30),

              // tombol simpan
              SizedBox(
                width: double.infinity,

                child: Container(
                  decoration: BoxDecoration(
                    gradient: AuthTheme.buttonGradient,

                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,

                      shadowColor: Colors.transparent,

                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),

                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            // cek password sama
                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Konfirmasi password tidak cocok",
                                  ),
                                ),
                              );

                              return;
                            }

                            // update password
                            final success = await provider.changePassword(
                              oldPassword: oldPasswordController.text,

                              newPassword: newPasswordController.text,
                            );

                            if (!mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.successMessage ??
                                        "Password berhasil diubah",
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.errorMessage ??
                                        "Terjadi kesalahan",
                                  ),
                                ),
                              );
                            }
                          },

                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,

                            width: 20,

                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Ubah Password",

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
        ),
      ),
    );
  }

  // widget input password
  Widget _passwordField({
    required TextEditingController controller,

    required String hint,

    required bool obscure,

    required IconData icon,

    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,

      obscureText: obscure,

      style: const TextStyle(color: AuthTheme.title),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(color: AuthTheme.hint),

        prefixIcon: Icon(icon, color: AuthTheme.blueGlow),

        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,

            color: AuthTheme.subtitle,
          ),

          onPressed: onTap,
        ),

        filled: true,

        fillColor: AuthTheme.inputFill,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
