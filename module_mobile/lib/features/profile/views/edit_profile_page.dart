import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/theme/auth_theme.dart';

import '../viewmodels/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isLoaded) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      final profile = provider.profile;

      if (profile != null) {
        nameController.text = profile["name"] ?? "";

        emailController.text = profile["email"] ?? "";

        phoneController.text = profile["phone"] ?? "";
      }

      isLoaded = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();

    emailController.dispose();

    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: AuthTheme.background,

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
              "Edit Profile",

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
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: AuthTheme.cardBackground,

            borderRadius: BorderRadius.circular(22),

            border: Border.all(color: AuthTheme.border),
          ),

          child: Column(
            children: [
              _field(
                controller: nameController,

                hint: "Nama",

                icon: Icons.person,
              ),

              const SizedBox(height: 15),

              _field(
                controller: emailController,

                hint: "Email",

                icon: Icons.email,
              ),

              const SizedBox(height: 15),

              _field(
                controller: phoneController,

                hint: "Nomor HP",

                icon: Icons.phone,
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

                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            final success = await provider.updateProfile(
                              name: nameController.text.trim(),

                              email: emailController.text.trim(),

                              phone: phoneController.text.trim(),
                            );

                            if (!mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.successMessage ??
                                        "Profile berhasil diperbarui",
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

  Widget _field({
    required TextEditingController controller,

    required String hint,

    required IconData icon,
  }) {
    return TextField(
      controller: controller,

      style: const TextStyle(color: AuthTheme.title),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(color: AuthTheme.hint),

        prefixIcon: Icon(icon, color: AuthTheme.blueGlow),

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
