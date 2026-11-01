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
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? 55,
    child: Material(
      color: color ?? Colors.black,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: color ?? Colors.black, width: 1),
          ),
          child:
              child ??
              Text(
                text ?? 'Press Button',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  letterSpacing: 0.2,
                ),
              ),
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
  return SizedBox(
    width: width ?? 40,
    height: height ?? 40,
    child: Material(
      color: color ?? Color(0xFFF3F3F3),
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          alignment: Alignment.center,
          child:
              child ??
              Icon(
                icon ?? Icons.add,
                color: iconColor ?? Colors.black,
                size: iconSize,
              ),
        ),
      ),
    ),
  );
}
