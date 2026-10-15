import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future addProduct({
  required String name,
  required String price,
  required String image,
  required String category,
  required String description,
  required bool orderAvailable,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('Please login first');
  }

  await FirebaseFirestore.instance.collection('products').add({
    'name': name,
    'price': price,
    'image': image,
    'category': category,
    'description': description,
    'orderAvailable': orderAvailable,
    'userId': user.uid,

    'createdAt': FieldValue.serverTimestamp(),
  });
}

Future saveProduct({
  required BuildContext context,
  required String name,
  required String price,
  required String image,
  required String category,
  required String description,
  required bool orderAvailable,
  String? productId,
}) async {
  if (name.trim().isEmpty ||
      price.trim().isEmpty ||
      image.trim().isEmpty ||
      description.trim().isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));

    return false;
  }

  try {
    await addProduct(
      name: name.trim(),
      price: price.trim(),
      image: image.trim(),
      category: category,
      description: description.trim(),
      orderAvailable: orderAvailable,
    );

    if (!context.mounted) return true;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added successfully')));

    return true;
  } catch (e) {
    if (!context.mounted) return false;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $e')));

    return false;
  }
}
