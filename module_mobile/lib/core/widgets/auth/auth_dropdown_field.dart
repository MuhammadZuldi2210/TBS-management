// import flutter material
import 'package:flutter/material.dart';

// import auth theme
import '../../theme/auth_theme.dart';

// Dropdown khusus halaman autentikasi
class AuthDropdownField<T> extends StatelessWidget {
  // value terpilih
  final T? value;

  // hint
  final String hintText;

  // icon kiri
  final IconData prefixIcon;

  // item dropdown
  final List<DropdownMenuItem<T>> items;

  // ketika value berubah
  final ValueChanged<T?>? onChanged;

  // validator
  final String? Function(T?)? validator;

  const AuthDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      // tulisan saat belum memilih admin
      hint: Text(
        hintText,
        style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
      ),
      validator: validator,
      dropdownColor: AuthTheme.inputFill,
      iconEnabledColor: AuthTheme.blueGlow,
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
