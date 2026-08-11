// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import admin provider
import '../viewmodels/admin_provider.dart';

class EditAdminPage extends StatefulWidget {
  // data admin
  final Map<String, dynamic> admin;

  const EditAdminPage({super.key, required this.admin});

  @override
  State<EditAdminPage> createState() => _EditAdminPageState();
}

class _EditAdminPageState extends State<EditAdminPage> {
  // controller
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    // isi data awal
    nameController = TextEditingController(text: widget.admin["name"] ?? "");

    emailController = TextEditingController(text: widget.admin["email"] ?? "");
  }

  @override
  void dispose() {
    // hapus controller
    nameController.dispose();
    emailController.dispose();

    super.dispose();
  }

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

        // logo dan title
        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 35),

            const SizedBox(width: 10),

            const Text(
              "Edit Admin",

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

          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: AuthTheme.cardBackground,

            borderRadius: BorderRadius.circular(22),

            border: Border.all(color: AuthTheme.border),

            boxShadow: [
              BoxShadow(
                color: AuthTheme.blueGlow.withValues(alpha: 0.15),

                blurRadius: 20,
              ),
            ],
          ),

          child: Column(
            children: [
              // icon admin
              CircleAvatar(
                radius: 40,

                backgroundColor: AuthTheme.blueGlow.withValues(alpha: 0.15),

                child: const Icon(
                  Icons.admin_panel_settings,

                  size: 45,

                  color: AuthTheme.blueGlow,
                ),
              ),

              const SizedBox(height: 25),

              // input nama
              TextField(
                controller: nameController,

                style: const TextStyle(color: AuthTheme.title),

                decoration: const InputDecoration(
                  labelText: "Nama",

                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              // input email
              TextField(
                controller: emailController,

                style: const TextStyle(color: AuthTheme.title),

                decoration: const InputDecoration(
                  labelText: "Email",

                  prefixIcon: Icon(Icons.email),
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
                      // ambil provider
                      final provider = context.read<AdminProvider>();

                      // update admin
                      final success = await provider.updateAdmin(
                        id: widget.admin["_id"],

                        name: nameController.text,

                        email: emailController.text,
                      );

                      // kembali jika berhasil
                      if (success) {
                        Navigator.pop(context);
                      }
                    },

                    child: const Text(
                      "Simpan",

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
}
