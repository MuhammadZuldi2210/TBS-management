// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import auth theme
import '../../../core/theme/auth_theme.dart';

// import auth provider
import '../../auth/viewmodels/auth_provider.dart';

// import profile provider
import '../viewmodels/profile_provider.dart';

// import edit profile page
import '../views/edit_profile_page.dart';

// import change password page
import 'change_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    // ambil data profile
    Future.microtask(() {
      context.read<ProfileProvider>().getProfile();
    });
  }

  // ===============================
  // LOGOUT
  // ===============================
  Future _logout() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AuthTheme.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AuthTheme.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.35),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Konfirmasi Logout",
                  style: TextStyle(
                    color: AuthTheme.title,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Apakah kamu yakin ingin keluar dari akun ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AuthTheme.subtitle, fontSize: 14),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.white.withOpacity(.15),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: AuthTheme.subtitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm != true) return;

    await context.read<AuthProvider>().logout();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    // provider profile
    final profileProvider = Provider.of<ProfileProvider>(context);

    // data profile
    final profile = profileProvider.profile;

    final String name = profile?["name"] ?? "-";

    final String role = (profile?["role"] ?? "-")
        .toString()
        .replaceAll("_", " ")
        .toUpperCase();

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ===============================
      // APP BAR
      // ===============================
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        titleSpacing: 20,

        title: Row(
          children: [
            Image.asset("assets/logos/TBS.png", height: 32),

            const SizedBox(width: 10),

            const Text(
              "Profile",
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(.10),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.redAccent.withOpacity(.18)),
            ),
            child: IconButton(
              tooltip: "Logout",
              onPressed: _logout,
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
                size: 21,
              ),
            ),
          ),
        ],
      ),

      // ===============================
      // BODY
      // ===============================
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===============================
                  // PROFILE HERO
                  // ===============================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AuthTheme.blueGlow.withOpacity(.20),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(.15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(.30),
                                  width: 2,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(.12),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 9),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.14),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(.12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified_user_rounded,
                                size: 15,
                                color: Colors.white,
                              ),

                              const SizedBox(width: 7),

                              Text(
                                role,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(.12),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shield_rounded,
                              size: 17,
                              color: Colors.white.withOpacity(.75),
                            ),

                            const SizedBox(width: 7),

                            Text(
                              "Account Information",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.75),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ===============================
                  // SECTION TITLE
                  // ===============================
                  const Text(
                    "Informasi Akun",
                    style: TextStyle(
                      color: AuthTheme.title,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===============================
                  // DETAIL CARD
                  // ===============================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AuthTheme.cardBackground,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AuthTheme.border),
                    ),
                    child: Column(
                      children: [
                        _item(
                          Icons.person_outline_rounded,
                          "Nama",
                          profile?["name"] ?? "-",
                        ),

                        _divider(),

                        _item(
                          Icons.email_outlined,
                          "Email",
                          profile?["email"] ?? "-",
                        ),

                        _divider(),

                        _item(
                          Icons.phone_outlined,
                          "Phone",
                          profile?["phone"] ?? "-",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ===============================
                  // SECTION TITLE
                  // ===============================
                  const Text(
                    "Pengaturan Akun",
                    style: TextStyle(
                      color: AuthTheme.title,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===============================
                  // EDIT PROFILE
                  // ===============================
                  _actionCard(
                    icon: Icons.edit_rounded,
                    title: "Edit Profile",
                    subtitle: "Ubah informasi profile Anda",
                    gradient: AuthTheme.buttonGradient,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    },
                    filled: true,
                  ),

                  const SizedBox(height: 12),

                  // ===============================
                  // CHANGE PASSWORD
                  // ===============================
                  _actionCard(
                    icon: Icons.lock_outline_rounded,
                    title: "Ubah Password",
                    subtitle: "Perbarui password akun Anda",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  // ===============================
  // DIVIDER
  // ===============================
  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(height: 1, color: AuthTheme.border),
    );
  }

  // ===============================
  // PROFILE ITEM
  // ===============================
  Widget _item(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AuthTheme.blueGlow.withOpacity(.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, size: 21, color: AuthTheme.blueGlow),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AuthTheme.subtitle, fontSize: 12),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AuthTheme.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===============================
  // ACTION CARD
  // ===============================
  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Gradient? gradient,
    bool filled = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        color: filled ? null : AuthTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: filled ? Colors.transparent : AuthTheme.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: filled
                        ? Colors.white.withOpacity(.15)
                        : AuthTheme.blueGlow.withOpacity(.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: filled ? Colors.white : AuthTheme.blueGlow,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: filled ? Colors.white : AuthTheme.title,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        style: TextStyle(
                          color: filled
                              ? Colors.white.withOpacity(.70)
                              : AuthTheme.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: filled
                      ? Colors.white.withOpacity(.75)
                      : AuthTheme.subtitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
