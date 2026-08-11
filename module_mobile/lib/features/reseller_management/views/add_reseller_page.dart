// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import reseller provider
import '../viewmodels/reseller_provider.dart';

class AddResellerPage extends StatefulWidget {
  const AddResellerPage({super.key});

  @override
  State<AddResellerPage> createState() => _AddResellerPageState();
}

class _AddResellerPageState extends State<AddResellerPage> {
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
              "Tambah reseller",

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
              "Data Reseller Baru",

              style: TextStyle(
                color: AuthTheme.title,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nameController,

              style: const TextStyle(color: AuthTheme.title),

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: AuthTheme.blueGlow),

                hintText: "Nama Reseller",

                hintStyle: const TextStyle(color: AuthTheme.hint),

                filled: true,

                fillColor: AuthTheme.inputFill,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

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
                    final provider = context.read<ResellerProvider>();

                    final result = await provider.createReseller(
                      name: nameController.text,

                      email: emailController.text,

                      password: passwordController.text,

                      phone: phoneController.text,
                    );

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Reseller berhasil ditambahkan"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },

                  child: const Text(
                    "Simpan Reseller",

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
