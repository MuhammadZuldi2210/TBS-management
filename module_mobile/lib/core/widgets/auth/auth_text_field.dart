// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// TextField khusus halaman autentikasi
class AuthTextField extends StatelessWidget {
  // Controller
  final TextEditingController controller;

  // Hint
  final String hintText;

  // Icon kiri
  final IconData prefixIcon;

  // Password atau bukan
  final bool obscureText;

  // Icon kanan
  final Widget? suffixIcon;

  // Keyboard type
  final TextInputType keyboardType;

  // Validator
  final String? Function(String?)? validator;

  // Next / Done
  final TextInputAction? textInputAction;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,

      style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(
          color: AuthTheme.hint,
          fontFamily: "Poppins",
        ),

        filled: true,
        fillColor: AuthTheme.inputFill,

        prefixIcon: Icon(prefixIcon, color: AuthTheme.blueGlow),

        suffixIcon: suffixIcon,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AuthTheme.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AuthTheme.blueGlow, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
