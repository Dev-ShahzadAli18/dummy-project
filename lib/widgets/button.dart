import 'package:flutter/material.dart';

Widget customButton({
  String? text,
  Widget? child,
  VoidCallback? onTap,
  double? width,
  double? height,
  Color? color,
  Color? textColor,
  double borderRadius = 12,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.bold,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width ?? double.infinity,
      height: height ?? 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.black,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child:
          child ??
          Text(
            text ?? 'Press Button',
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
    ),
  );
}

Widget customIconButton({
  IconData? icon,
  Widget? child,
  VoidCallback? onTap,
  double? width,
  double? height,
  Color? color,
  Color? iconColor,
  double iconSize = 24,
  double borderRadius = 12,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width ?? 40,
      height: height ?? 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child:
          child ??
          Icon(
            icon ?? Icons.add,
            color: iconColor ?? Colors.black,
            size: iconSize,
          ),
    ),
  );
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Icon(icon, size: 17),
      ),
    );
  }
}
