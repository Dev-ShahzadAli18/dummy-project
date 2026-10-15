import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/services/productservice.dart' as product_service;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future editProduct({
  required String productId,
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
  final productRef = FirebaseFirestore.instance
      .collection('products')
      .doc(productId);
  final snapshot = await productRef.get();
  if (!snapshot.exists) {
    throw Exception('Product not found');
  }
  await productRef.update({
    'name': name.trim(),
    'price': price.trim(),
    'image': image.trim(),
    'category': category,
    'description': description.trim(),
    'orderAvailable': orderAvailable,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

Future deleteProduct({required String productId}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('Please login first');
  }
  final productRef = FirebaseFirestore.instance
      .collection('products')
      .doc(productId);
  final snapshot = await productRef.get();
  if (!snapshot.exists) {
    throw Exception('Product not found');
  }
  await productRef.delete();
}

Future submitProduct({
  required BuildContext context,
  required String? productId,
  required String name,
  required String price,
  required String image,
  required String category,
  required String description,
  required bool orderAvailable,
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
    if (productId == null) {
      await product_service.saveProduct(
        context: context,
        name: name,
        price: price,
        image: image,
        category: category,
        description: description,
        orderAvailable: orderAvailable,
      );
    } else {
      await editProduct(
        productId: productId,
        name: name,
        price: price,
        image: image,
        category: category,
        description: description,
        orderAvailable: orderAvailable,
      );
    }

    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    return false;
  }
}

Future updateProfile({
  required String uid,
  required String field,
  required String value,
  required Function(String message) onError,
}) async {
  try {
    final newValue = value.trim();

    if (newValue.isEmpty) {
      onError('Value cannot be empty');
      return false;
    }

    if (field == 'role') {
      onError('Role cannot be updated');
      return false;
    }

    await FirebaseFirestore.instance.collection('Users').doc(uid).update({
      field: newValue,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  } catch (e) {
    onError('Update failed: $e');
    return false;
  }
}
