// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import reseller provider
import '../viewmodels/reseller_provider.dart';

class EditResellerPage extends StatefulWidget {
  // data reseller
  final Map<String, dynamic> reseller;

  const EditResellerPage({super.key, required this.reseller});

  @override
  State<EditResellerPage> createState() => _EditResellerPageState();
}

class _EditResellerPageState extends State<EditResellerPage> {
  // controller
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
            Image.asset("assets/logos/TBS.png", height: 35),

            const SizedBox(width: 10),

            const Text(
              "Edit Reseller",

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
              // icon reseller
              CircleAvatar(
                radius: 40,

                backgroundColor: Colors.orange.withValues(alpha: 0.15),

                child: const Icon(Icons.store, size: 45, color: Colors.orange),
              ),

              const SizedBox(height: 25),

              // nama
              TextField(
                controller: nameController,

                style: const TextStyle(color: AuthTheme.title),

                decoration: const InputDecoration(
                  labelText: "Nama Reseller",

                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              // phone
              TextField(
                controller: phoneController,

                keyboardType: TextInputType.phone,

                style: const TextStyle(color: AuthTheme.title),

                decoration: const InputDecoration(
                  labelText: "Phone",

                  prefixIcon: Icon(Icons.phone),
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
                      final provider = context.read<ResellerProvider>();

                      final success = await provider.updateReseller(
                        resellerId: widget.reseller["_id"],

                        name: nameController.text,

                        phone: phoneController.text,
                      );

                      if (success && mounted) {
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
