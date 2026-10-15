import 'package:flutter/material.dart';

Widget cartEmptyIcon() {
  return Container(
    height: 130,
    width: 130,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.shopping_cart_outlined,
      size: 65,
      color: Colors.grey.shade600,
    ),
  );
}

Widget cartPageTitle({required String title, required String subtitle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
    ],
  );
}

Widget cartProductImage({required String image}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: image.isNotEmpty
        ? Image.network(
            image,
            width: 100,
            height: 115,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 115,
                color: Colors.grey.shade200,
                child: Icon(Icons.image_not_supported_outlined, size: 35),
              );
            },
          )
        : Container(
            width: 100,
            height: 115,
            color: Colors.grey.shade200,
            child: Icon(Icons.shopping_bag_outlined, size: 35),
          ),
  );
}

Widget cartQuantityButton({
  required IconData icon,
  required VoidCallback onTap,
  bool isAdd = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isAdd ? Colors.black : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: IconButton(
      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
      padding: EdgeInsets.zero,
      iconSize: 19,
      color: isAdd ? Colors.white : Colors.black,
      onPressed: onTap,
      icon: Icon(icon),
    ),
  );
}

Widget cartPriceSummary({
  required String title,
  required String value,
  bool isTotal = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: isTotal ? 18 : 15,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? null : Colors.grey.shade600,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: isTotal ? 22 : 15,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    ],
  );
}
