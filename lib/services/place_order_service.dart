import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

Future placeOrder({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required bool isPlacingOrder,
  required VoidCallback setLoading,
  required VoidCallback resetLoading,
  required Map<String, dynamic> product,
  required TextEditingController nameController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required int quantity,
  required String selectedColor,
  required double productPrice,
  required double totalPrice,
}) async {
  if (isPlacingOrder) return;

  if (!formKey.currentState!.validate()) return;

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Please login first')));
    return;
  }

  setLoading();

  try {
    final productId = (product['productId'] ?? product['id'] ?? '').toString();

    if (productId.isEmpty) {
      throw Exception('Product ID not found');
    }

    final productSnapshot = await _db
        .collection('products')
        .doc(productId)
        .get();

    if (!productSnapshot.exists) {
      throw Exception('Product no longer exists');
    }

    final productData = productSnapshot.data()!;
    final adminId = (productData['userId'] ?? '').toString();

    if (adminId.isEmpty) {
      throw Exception('Product owner ID is missing');
    }

    if (productData['orderAvailable'] == false) {
      throw Exception('This product is not available for ordering');
    }

    final customerSnapshot = await _db.collection('users').doc(user.uid).get();

    final customerData = customerSnapshot.data() ?? {};
    var adminSnapshot = await _db.collection('users').doc(adminId).get();

    if (!adminSnapshot.exists) {
      adminSnapshot = await _db.collection('Users').doc(adminId).get();
    }

    final adminData = adminSnapshot.data() ?? {};

    final orderRef = _db.collection('orders').doc();
    final userOrderRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderRef.id);

    final orderData = <String, dynamic>{
      'orderId': orderRef.id,
      'userId': user.uid,
      'customerName': nameController.text.trim(),
      'customerEmail': user.email ?? '',
      'customerPhone': phoneController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'customerNameFromProfile':
          (customerData['name'] ?? customerData['fullName'] ?? '').toString(),
      'adminId': adminId,
      'adminName': (adminData['name'] ?? adminData['fullName'] ?? '')
          .toString(),
      'adminEmail': (adminData['email'] ?? '').toString(),
      'productId': productId,
      'productName': (productData['name'] ?? product['name'] ?? 'Product')
          .toString(),
      'productImage': (productData['image'] ?? product['image'] ?? '')
          .toString(),
      'product': <String, dynamic>{
        ...productData,
        'id': productId,
        'productId': productId,
      },
      'quantity': quantity,
      'selectedColor': selectedColor,
      'price': productPrice,
      'totalPrice': totalPrice,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final batch = _db.batch();
    batch.set(orderRef, orderData);
    batch.set(userOrderRef, orderData);
    await batch.commit();

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));

    Navigator.pop(context);
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
  } finally {
    if (context.mounted) {
      resetLoading();
    }
  }
}

Stream<QuerySnapshot<Map<String, dynamic>>> getMyOrders() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return _db
      .collection('users')
      .doc(user.uid)
      .collection('orders')
      .orderBy('createdAt', descending: true)
      .snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getAdminOrders() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return _db
      .collection('orders')
      .where('adminId', isEqualTo: user.uid)
      .snapshots();
}

Future updateOrderStatus({
  required String orderId,
  required String customerId,
  required String newStatus,
}) async {
  final admin = FirebaseAuth.instance.currentUser;

  if (admin == null) {
    throw Exception('Please login first');
  }

  const allowedStatuses = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  if (!allowedStatuses.contains(newStatus)) {
    throw Exception('Invalid order status');
  }

  final sharedOrderRef = _db.collection('orders').doc(orderId);

  final userOrderRef = _db
      .collection('users')
      .doc(customerId)
      .collection('orders')
      .doc(orderId);
  final orderSnapshot = await sharedOrderRef.get();

  if (!orderSnapshot.exists) {
    throw Exception('Order not found');
  }

  final orderData = orderSnapshot.data()!;

  if (orderData['adminId'] != admin.uid) {
    throw Exception('You cannot update another admin\'s order');
  }

  if (orderData['userId'] != customerId) {
    throw Exception('Customer ID does not match this order');
  }

  final batch = _db.batch();

  final updates = {
    'status': newStatus,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  batch.update(sharedOrderRef, updates);
  batch.update(userOrderRef, updates);

  await batch.commit();
}
