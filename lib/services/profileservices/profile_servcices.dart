import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/services/profileservices/productimageservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileServices {
  static const String cloudName = 'cv1adbod';
  static const String uploadPreset = 'profile_upload';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileData() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please login first');
    }

    return _firestore.collection('Users').doc(user.uid).snapshots();
  }

  Future<String> uploadProfileImage(File image) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please login first');
    }

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = 'profile_images'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final result = jsonDecode(responseBody);

    if (response.statusCode != 200) {
      throw Exception(result['error']?['message'] ?? 'Image upload failed');
    }

    final imageUrl = result['secure_url'] as String;

    await _firestore.collection('Users').doc(user.uid).set({
      'profileImage': imageUrl,
    }, SetOptions(merge: true));

    return imageUrl;
  }

  Future<Map<String, dynamic>?> getProfileOnce() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please login first');
    }

    final snapshot = await _firestore.collection('Users').doc(user.uid).get();

    return snapshot.data();
  }

  Future<String?> pickAndUploadProfileImage(ImageSource source) async {
    final ProfileImageServices imageServices = ProfileImageServices();

    final File? image = await imageServices.pickProfileImage(source: source);

    if (image == null) {
      return null;
    }

    return await uploadProfileImage(image);
  }
}
