// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import provider
import 'package:provider/provider.dart';

// import admin provider
import '../viewmodels/admin_provider.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  // Controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // Password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background
      backgroundColor: AuthTheme.background,

      // appbar
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,
        // tombol kembali
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
              "Tambah admin",
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

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // judul
            const Text(
              "Data Admin Baru",
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // nama admin
            TextField(
              controller: nameController,
              style: const TextStyle(color: AuthTheme.title),

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: AuthTheme.blueGlow),

                hintText: "Nama Admin",

                hintStyle: const TextStyle(color: AuthTheme.hint),

                filled: true,

                fillColor: AuthTheme.inputFill,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,

              style: const TextStyle(color: AuthTheme.title),

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: AuthTheme.blueGlow),

                hintText: "Email",

                hintStyle: const TextStyle(color: AuthTheme.hint),

                filled: true,

                fillColor: AuthTheme.inputFill,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
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

            // nomor hp
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,

              style: const TextStyle(color: AuthTheme.title),

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone, color: AuthTheme.blueGlow),

                hintText: "Nomor HP",

                hintStyle: const TextStyle(color: AuthTheme.hint),

                filled: true,

                fillColor: AuthTheme.inputFill,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
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

                  onPressed: () async {
                    final provider = context.read<AdminProvider>();

                    final result = await provider.createAdmin(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      phone: phoneController.text,
                    );

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Admin berhasil ditambahkan"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },

                  child: const Text(
                    "Simpan Admin",
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
}
