// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import provider user
import '../viewmodels/user_management_provider.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // Password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
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
              "Tambah User",
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

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Data User Baru",
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // nama
            _inputField(
              controller: nameController,
              icon: Icons.person,
              hint: "Nama User",
            ),

            const SizedBox(height: 15),

            // email
            _inputField(
              controller: emailController,
              icon: Icons.email,
              hint: "Email",
            ),

            const SizedBox(height: 15),

            // password
            TextField(
              controller: passwordController,

              // tampil/sembunyikan password
              obscureText: !_isPasswordVisible,

              style: const TextStyle(color: AuthTheme.title),

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: AuthTheme.blueGlow),

                hintText: "Password",

                hintStyle: const TextStyle(color: AuthTheme.hint),

                filled: true,

                fillColor: AuthTheme.inputFill,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                // 👁️ tombol lihat password
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },

                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,

                    color: AuthTheme.blueGlow,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // phone
            _inputField(
              controller: phoneController,
              icon: Icons.phone,
              hint: "Nomor HP",
            ),

            const SizedBox(height: 30),

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

                  onPressed: () async {
                    final provider = context.read<UserManagementProvider>();

                    final result = await provider.createUser(
                      name: nameController.text,

                      email: emailController.text,

                      password: passwordController.text,

                      phone: phoneController.text,
                    );

                    if (result && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User berhasil ditambahkan"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },

                  child: const Text(
                    "Simpan User",
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
    );
  }

  // widget input
  Widget _inputField({
    required TextEditingController controller,

    required IconData icon,

    required String hint,

    bool obscure = false,
  }) {
    return TextField(
      controller: controller,

      obscureText: obscure,

      style: const TextStyle(color: AuthTheme.title),

      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AuthTheme.blueGlow),

        hintText: hint,

        hintStyle: const TextStyle(color: AuthTheme.hint),

        filled: true,

        fillColor: AuthTheme.inputFill,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
