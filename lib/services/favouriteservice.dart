import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future checkFavorite({required String productId}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null || productId.isEmpty) {
    return false;
  }

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .doc(productId)
      .get();

  return doc.exists;
}

Future toggleFavorite({
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

  final ref = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .doc(productId);

  final doc = await ref.get();

  if (doc.exists) {
    await ref.delete();
    return false;
  }

  await ref.set({
    ...product,
    'id': productId,
    'productId': productId,
    'addedAt': FieldValue.serverTimestamp(),
  });

  return true;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getFavorites() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .orderBy('addedAt', descending: true)
      .snapshots();
}

Future removeFavorite({required String productId}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('Please login first');
  }

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .doc(productId)
      .delete();
}
