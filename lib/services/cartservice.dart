import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/orderdetalpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _cart = FirebaseFirestore.instance;
Future addToCart({
  required String productId,
  required Map<String, dynamic> product,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('Please login first');
  }

  if (productId.isEmpty) {
    throw Exception('Product ID not found');
  }

  final productSnapshot = await _cart
      .collection('products')
      .doc(productId)
      .get();

  if (!productSnapshot.exists) {
    throw Exception('Product not found');
  }

  final productData = productSnapshot.data()!;
  final adminId = (productData['userId'] ?? '').toString();

  if (adminId.isEmpty) {
    throw Exception('Product owner ID is missing');
  }

  if (productData['orderAvailable'] == false) {
    throw Exception('This product is not available');
  }

  final cartRef = _cart
      .collection('users')
      .doc(user.uid)
      .collection('cart')
      .doc(productId);

  await _cart.runTransaction((transaction) async {
    final snapshot = await transaction.get(cartRef);

    if (snapshot.exists) {
      final currentQuantity = snapshot.data()?['quantity'] ?? 1;

      transaction.update(cartRef, {
        'quantity': (currentQuantity as num).toInt() + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      transaction.set(cartRef, {
        ...productData,
        'id': productId,
        'productId': productId,
        'userId': user.uid,
        'adminId': adminId,
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  });
}

Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return _cart.collection('users').doc(user.uid).collection('cart').snapshots();
}

Future updateCartQuantity({
  required String productId,
  required int quantity,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('Please login first');
  }

  final ref = _cart
      .collection('users')
      .doc(user.uid)
      .collection('cart')
      .doc(productId);

  if (quantity <= 0) {
    await ref.delete();
  } else {
    await ref.update({
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

Future removeFromCart({required String productId}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('Please login first');
  }

  await _cart
      .collection('users')
      .doc(user.uid)
      .collection('cart')
      .doc(productId)
      .delete();
}

Future orderNow({
  required BuildContext context,
  required Map<String, dynamic> product,
}) async {
  try {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(product: product),
      ),
    );

    return true;
  } catch (e) {
    if (!context.mounted) return false;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $e')));

    return false;
  }
}
