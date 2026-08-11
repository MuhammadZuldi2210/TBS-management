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
  // controller email
  final emailController = TextEditingController();

  // controller password
  final passwordController = TextEditingController();

  // show hide password
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return AuthBackground(
      child: AuthCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // logo
            const AuthLogo(),

            const SizedBox(height: 24),

            // title
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
                fontSize: 28,
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

            const SizedBox(height: 35),

            // email
            AuthTextField(
              controller: emailController,
              hintText: "Email",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 18),

            // password
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
            // error message
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

            // success message
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

            // forgot password
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

            // login button
            AuthButton(
              title: "LOG IN",
              isLoading: auth.isLoading,
              onPressed: () async {
                await auth.login(
                  emailController.text.trim(),
                  passwordController.text,
                );

                if (auth.isLoggedIn && mounted) {
                  Navigator.pushReplacementNamed(context, "/dashboard");
                }
              },
            ),

            const SizedBox(height: 25),

            // register
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
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
    );
  }
}
