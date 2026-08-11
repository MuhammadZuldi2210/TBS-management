// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// Tombol khusus halaman autentikasi
class AuthButton extends StatelessWidget {
  // Judul tombol
  final String title;

  // Event ketika tombol ditekan
  final VoidCallback? onPressed;

  // Status loading
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,

      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AuthTheme.buttonGradient,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: AuthTheme.blueGlow.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
