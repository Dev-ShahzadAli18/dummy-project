import 'package:flutter/material.dart';

Widget detailRow({required IconData icon, required String value}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
