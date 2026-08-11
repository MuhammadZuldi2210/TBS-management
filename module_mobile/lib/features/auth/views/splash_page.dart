// Mengimpor package Material Flutter
import 'package:flutter/material.dart';

// Import auth provider
import '../viewmodels/auth_provider.dart';

// Provider state management
import 'package:provider/provider.dart';

// Auth Theme
import '../../../core/theme/auth_theme.dart';

// ==========================================
// SPLASH PAGE
// ==========================================

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

// ==========================================
// SPLASH STATE
// ==========================================

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _contentController;
  late AnimationController _loadingController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // ==========================================
    // CONTENT ANIMATION
    // ==========================================

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutBack),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    // ==========================================
    // LOADING ANIMATION
    // ==========================================

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();

    // Mulai animasi
    _contentController.forward();

    // Jalankan proses aplikasi
    _initializeApp();
  }

  // ==========================================
  // INITIALIZE APP
  // ==========================================

  Future<void> _initializeApp() async {
    // Waktu minimum splash
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Cek token / login
    await auth.initAuth();

    if (!mounted) return;

    // ==========================================
    // NAVIGASI
    // ==========================================

    if (auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _loadingController.dispose();

    super.dispose();
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.background,

      body: Stack(
        children: [
          // ==========================================
          // BACKGROUND GLOW
          // ==========================================
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AuthTheme.blueGlow.withValues(alpha: .08),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -120,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AuthTheme.blueGlow.withValues(alpha: .05),
              ),
            ),
          ),

          // ==========================================
          // MAIN CONTENT
          // ==========================================
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,

                child: SlideTransition(
                  position: _slideAnimation,

                  child: ScaleTransition(
                    scale: _scaleAnimation,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        // ==========================================
                        // LOGO
                        // ==========================================
                        Container(
                          width: 135,
                          height: 135,

                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            color: AuthTheme.cardBackground,

                            borderRadius: BorderRadius.circular(36),

                            border: Border.all(
                              color: AuthTheme.border,
                              width: 1.2,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: AuthTheme.blueGlow.withValues(
                                  alpha: .18,
                                ),

                                blurRadius: 35,

                                spreadRadius: 4,

                                offset: const Offset(0, 12),
                              ),

                              BoxShadow(
                                color: Colors.black.withValues(alpha: .25),

                                blurRadius: 20,

                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),

                          child: Image.asset(
                            "assets/logos/TBS.png",

                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==========================================
                        // APP NAME
                        // ==========================================
                        const Text(
                          "TBS Management",

                          style: TextStyle(
                            color: AuthTheme.title,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ==========================================
                        // SUBTITLE
                        // ==========================================
                        Text(
                          "Management System",

                          style: TextStyle(
                            color: AuthTheme.subtitle.withValues(alpha: .75),

                            fontSize: 13,

                            fontWeight: FontWeight.w500,

                            letterSpacing: 1.4,
                          ),
                        ),

                        const SizedBox(height: 38),

                        // ==========================================
                        // CUSTOM LOADING
                        // ==========================================
                        _buildLoading(),

                        const SizedBox(height: 14),

                        // ==========================================
                        // LOADING TEXT
                        // ==========================================
                        Text(
                          "Menyiapkan aplikasi...",

                          style: TextStyle(
                            color: AuthTheme.subtitle.withValues(alpha: .55),

                            fontSize: 11,

                            letterSpacing: .3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ==========================================
          // VERSION
          // ==========================================
          Positioned(
            bottom: 22,
            left: 0,
            right: 0,

            child: Text(
              "TBS Management • v1.0.0",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: AuthTheme.subtitle.withValues(alpha: .35),

                fontSize: 10,

                letterSpacing: .5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CUSTOM LOADING
  // ==========================================

  Widget _buildLoading() {
    return AnimatedBuilder(
      animation: _loadingController,

      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,

          children: List.generate(3, (index) {
            // Jarak animasi setiap titik
            final offset = (_loadingController.value + (index * 0.22)) % 1.0;

            // Membuat efek naik-turun
            final wave = (offset < 0.5) ? offset * 2 : (1 - offset) * 2;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),

              child: Transform.translate(
                offset: Offset(0, -wave * 6),

                child: Opacity(
                  opacity: 0.35 + (wave * 0.65),

                  child: Container(
                    width: 7,
                    height: 7,

                    decoration: BoxDecoration(
                      color: AuthTheme.blueGlow,

                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: AuthTheme.blueGlow.withValues(alpha: .35),

                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
