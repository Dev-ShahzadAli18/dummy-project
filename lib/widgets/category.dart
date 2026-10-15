import 'package:flutter/material.dart';

Widget category({
  required String selectedCategory,
  required Function(String) onCategorySelected,
}) {
  final categories = ['All', 'Men', 'Women', 'Beauty', 'Accessories'];

  return SizedBox(
    height: 45,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategory == category;

        return GestureDetector(
          onTap: () => onCategorySelected(category),
          child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    ),
  );
}
