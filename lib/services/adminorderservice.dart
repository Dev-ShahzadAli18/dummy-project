import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<QuerySnapshot<Map<String, dynamic>>> getAdminOrders() {
  final admin = FirebaseAuth.instance.currentUser;

  if (admin == null) {
    return Stream.empty();
  }
  return firestore
      .collection('orders')
      .where('adminId', isEqualTo: admin.uid)
      .snapshots();
}

Future updateAdminOrderStatus({
  required String orderId,
  required String customerId,
  required String newStatus,
}) async {
  final admin = FirebaseAuth.instance.currentUser;

  if (admin == null) {
    throw Exception('Please login first');
  }

  final allowedStatuses = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  if (!allowedStatuses.contains(newStatus)) {
    throw Exception('Invalid order status');
  }
  final orderRef = firestore.collection('orders').doc(orderId);
  final customerOrderRef = firestore
      .collection('users')
      .doc(customerId)
      .collection('orders')
      .doc(orderId);
  final orderSnapshot = await orderRef.get();
  if (!orderSnapshot.exists) {
    throw Exception('Order not found');
  }
  final order = orderSnapshot.data()!;
  if (order['adminId'] != admin.uid) {
    throw Exception('You cannot update another admin\'s order');
  }
  if (order['userId'] != customerId) {
    throw Exception('Customer ID does not match');
  }
  final customerOrderSnapshot = await customerOrderRef.get();
  if (!customerOrderSnapshot.exists) {
    throw Exception('Customer order record not found');
  }
  final batch = firestore.batch();
  final updates = <String, dynamic>{
    'status': newStatus,
    'updatedAt': FieldValue.serverTimestamp(),
  };
  batch.update(orderRef, updates);
  batch.update(customerOrderRef, updates);
  await batch.commit();
}
