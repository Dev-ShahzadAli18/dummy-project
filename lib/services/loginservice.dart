import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/Navigation.dart';
import 'package:dummy_project/pages/admin.dart';
import 'package:dummy_project/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

String userRole = 'User';

Future login(String email, String Password, BuildContext context) async {
  final user = await _auth.signInWithEmailAndPassword(
    email: email,
    password: Password,
  );

  final id = user.user!.uid;

  DocumentSnapshot userdoc = await _firestore.collection("Users").doc(id).get();

  if (userdoc.exists && userdoc.data() != null) {
    Map<String, dynamic> data = userdoc.data() as Map<String, dynamic>;

    userRole = data["role"] ?? "User";

    if (userRole == "Admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigation()),
      );
    }
  }
}

Future createaccount(
  String name,
  String email,
  String password,
  String confirmPassword,
  String userrole,
  String phone,
) async {
  try {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (user.user != null) {
      await _firestore.collection("Users").doc(user.user!.uid).set({
        "id": user.user!.uid,
        "UserName": name,
        "Email": email.trim(),
        "Phone": phone,
        "role": userrole,
        "CreatedDate": Timestamp.now(),
      });

      userRole = userrole;
      debugPrint('SIGNUP SUCCESS: ${user.user!.uid}');
    }
  } catch (e) {
    debugPrint('SIGNUP ERROR: $e');
    rethrow;
  }
}

Future roleCheck(BuildContext context) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
    return;
  }

  try {
    final userDoc = await _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .get();

    if (!context.mounted) return;

    if (!userDoc.exists || userDoc.data() == null) {
      await _auth.signOut();

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
      return;
    }

    final data = userDoc.data() as Map<String, dynamic>;
    userRole = data['role']?.toString() ?? 'User';

    if (userRole == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigation()),
      );
    }
  } catch (e) {
    debugPrint('Splash roleCheck error: $e');

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Unable to load profile: $e')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
}
