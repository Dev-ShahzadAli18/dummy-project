import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductImageServices {
  static const String cloudName = 'cv1adbod';
  static const String uploadPreset = 'product_upload';

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickProductImage() async {
    final XFile? selectedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (selectedFile == null) return null;

    return File(selectedFile.path);
  }

  Future<String> uploadProductImage(File image) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = 'product_images'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final result = jsonDecode(responseBody);

    if (response.statusCode != 200) {
      throw Exception(
        result['error']?['message'] ?? 'Product image upload failed',
      );
    }

    return result['secure_url'] as String;
  }
}
