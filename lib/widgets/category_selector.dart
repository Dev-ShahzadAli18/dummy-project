import 'package:flutter/material.dart';

Widget category({
  required String selectedCategory,
  required Function(String) onCategorySelected,
}) {
  final categories = ['All', 'Men', 'Women', 'Beauty', 'Accessories'];

  return SizedBox(
    height: 46,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (context, index) {
        return SizedBox(width: 10);
      },
      itemBuilder: (context, index) {
        final item = categories[index];
        final isSelected = selectedCategory == item;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onCategorySelected(item),
            borderRadius: BorderRadius.circular(30),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black
                    : Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? Colors.black
                      : Color.fromARGB(255, 232, 232, 232),
                ),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Color.fromARGB(255, 51, 51, 51),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
