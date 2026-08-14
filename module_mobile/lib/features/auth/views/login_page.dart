// import material
import 'package:flutter/material.dart';

// provider
import 'package:provider/provider.dart';

// auth provider
import '../viewmodels/auth_provider.dart';

// auth widgets
import '../../../core/widgets/auth/auth_background.dart';
import '../../../core/widgets/auth/auth_card.dart';
import '../../../core/widgets/auth/auth_logo.dart';
import '../../../core/widgets/auth/auth_text_field.dart';
import '../../../core/widgets/auth/auth_button.dart';

// auth theme
import '../../../core/theme/auth_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ==========================================================
  // CONTROLLER
  // ==========================================================

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // ==========================================================
  // STATE
  // ==========================================================

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // Ambil akun yang pernah login
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().loadSavedAccounts();
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // PILIH AKUN
  // ==========================================================

  void _selectAccount(Map<String, dynamic> account) {
    setState(() {
      emailController.text = account["email"]?.toString() ?? "";

      passwordController.text = account["password"]?.toString() ?? "";

      _obscurePassword = true;
    });
  }

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<void> _login(AuthProvider auth) async {
    await auth.login(emailController.text.trim(), passwordController.text);

    if (auth.isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, "/dashboard");
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return AuthBackground(
      child: AuthCard(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // LOGO
              // ==================================================
              const AuthLogo(),

              const SizedBox(height: 24),

              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                "WELCOME TO TBS",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Sign in to continue",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // AKUN TERSIMPAN
              // ==================================================
              if (auth.savedAccounts.isNotEmpty) ...[
                _buildSavedAccounts(auth),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: .15),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "atau login manual",
                        style: TextStyle(
                          color: Colors.white54,
                          fontFamily: "Poppins",
                          fontSize: 11,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: .15),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],

              // ==================================================
              // EMAIL
              // ==================================================
              AuthTextField(
                controller: emailController,
                hintText: "Email",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // PASSWORD
              // ==================================================
              AuthTextField(
                controller: passwordController,
                hintText: "Password",
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // ERROR MESSAGE
              // ==================================================
              if (auth.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    auth.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontFamily: "Poppins",
                      fontSize: 13,
                    ),
                  ),
                ),

              // ==================================================
              // SUCCESS MESSAGE
              // ==================================================
              if (auth.successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    auth.successMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: "Poppins",
                      fontSize: 13,
                    ),
                  ),
                ),

              // ==================================================
              // FORGOT PASSWORD
              // ==================================================
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // nanti kita buat halaman forgot password
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AuthTheme.blueGlow,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // LOGIN BUTTON
              // ==================================================
              AuthButton(
                title: "LOG IN",
                isLoading: auth.isLoading,
                onPressed: () async {
                  await _login(auth);
                },
              ),

              const SizedBox(height: 25),

              // ==================================================
              // FOOTER
              // ==================================================
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "TBS Management System",
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "Poppins",
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
  // SAVED ACCOUNTS
  // ==========================================================

  Widget _buildSavedAccounts(AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Akun tersimpan",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ...auth.savedAccounts.map((account) {
          final name = account["name"]?.toString() ?? "Pengguna";

          final email = account["email"]?.toString() ?? "";

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildSavedAccountItem(
              auth: auth,
              name: name,
              email: email,
              account: account,
            ),
          );
        }),
      ],
    );
  }

  // ==========================================================
  // SAVED ACCOUNT ITEM
  // ==========================================================

  Widget _buildSavedAccountItem({
    required AuthProvider auth,
    required String name,
    required String email,
    required Map<String, dynamic> account,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _selectAccount(account);
        },
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: .10)),
          ),
          child: Row(
            children: [
              // ==================================================
              // AVATAR
              // ==================================================
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: AuthTheme.buttonGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ==================================================
              // NAME + EMAIL
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontFamily: "Poppins",
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // DELETE ACCOUNT
              // ==================================================
              IconButton(
                tooltip: "Hapus akun tersimpan",
                onPressed: () async {
                  await _showDeleteAccountDialog(auth, name, email);
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white38,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DELETE ACCOUNT DIALOG
  // ==========================================================

  Future<void> _showDeleteAccountDialog(
    AuthProvider auth,
    String name,
    String email,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AuthTheme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Hapus akun?",
            style: TextStyle(
              color: AuthTheme.title,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Akun $name akan dihapus dari daftar akun tersimpan.",
            style: const TextStyle(
              color: AuthTheme.subtitle,
              fontFamily: "Poppins",
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                "Batal",
                style: TextStyle(color: AuthTheme.subtitle),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Hapus",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      await auth.removeSavedAccount(email);

      // Kalau akun yang sedang terisi adalah
      // akun yang baru saja dihapus,
      // kosongkan field.
      if (emailController.text.trim().toLowerCase() == email.toLowerCase()) {
        emailController.clear();
        passwordController.clear();
      }
    }
  }
}
