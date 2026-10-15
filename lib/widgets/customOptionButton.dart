import 'package:flutter/material.dart';

Widget customOptionButton({
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color.fromARGB(255, 252, 189, 2)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? const Color.fromARGB(255, 252, 190, 3)
              : Colors.grey.shade300,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
