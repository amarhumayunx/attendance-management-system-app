import 'package:flutter/material.dart';
class AdminFormFieldWidgets {

  static Widget buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
    String? helper,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
        hintText: helper,
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        fillColor: Colors.white.withOpacity(0.05),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.greenAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(color: Colors.white),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines ?? 1,
    );
  }

  static Widget buildDropdown<T>({
    required T value,
    required String label,
    required String? helper,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
        hintText: helper,
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        fillColor: Colors.white.withOpacity(0.05),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.greenAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      dropdownColor: const Color(0xFF1A1A2E),
      style: const TextStyle(color: Colors.white),
      icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  static Widget buildInfoBanner(String message, {Color? color, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (color ?? Colors.blue).withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (color ?? Colors.blue).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.info_outline, color: color ?? Colors.blueAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: (color ?? Colors.blueAccent).withOpacity(0.8),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildWarningBanner(String message) {
    return buildInfoBanner(
      message,
      color: Colors.orange,
      icon: Icons.warning_amber,
    );
  }

  static Widget buildErrorText(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget buildSubmitButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    required String text,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent.withOpacity(0.2),
          side: const BorderSide(color: Colors.greenAccent, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.greenAccent),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
