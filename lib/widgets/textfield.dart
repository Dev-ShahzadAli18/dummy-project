import 'package:flutter/material.dart';

Widget customTextField({
  String? hint,
  String? label,
  VoidCallback? ontap,
  bool obscureText = false,
  TextEditingController? controller,
  String? Function(String?)? validator,
  Widget? suffixicon,
  Widget? prefixicon,
  bool enabled = true,
  bool readOnly = false,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    onTap: ontap,
    obscureText: obscureText,
    enabled: enabled,
    readOnly: readOnly,
    keyboardType: keyboardType,
    maxLines: obscureText ? 1 : maxLines,
    decoration: InputDecoration(
      hintText: hint,
      labelText: label,
      suffixIcon: suffixicon,
      suffixIconColor: Colors.black,
      prefixIcon: prefixicon,
      hintStyle: TextStyle(color: Colors.black),
      labelStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black26, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
  );
}
