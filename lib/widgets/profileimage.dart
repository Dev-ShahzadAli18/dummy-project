import 'package:flutter/material.dart';

void showFullProfileImage(BuildContext context, String imageUrl) {
  if (imageUrl.isEmpty) return;

  showDialog(
    context: context,
    barrierColor: Colors.black,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 50,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      );
    },
  );
}
