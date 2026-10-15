import 'package:flutter/material.dart';

Widget orderAvailableWidget({
  required bool orderAvailable,
  required Function(bool) onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => onChanged(!orderAvailable),
      title: Text(
        orderAvailable ? "Orders are available" : "Orders are unavailable",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        orderAvailable
            ? "Customers can order this product"
            : "Customers cannot order this product",
        style: TextStyle(color: Colors.white60),
      ),
      trailing: Switch(
        value: orderAvailable,
        activeThumbColor: Colors.white,
        onChanged: onChanged,
      ),
    ),
  );
}
