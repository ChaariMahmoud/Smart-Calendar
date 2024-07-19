// ignore_for_file: avoid_print

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CameraService {
  final picker = ImagePicker();

  Future<File?> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<void> uploadImage(File image) async {
    final uri = Uri.parse('http://10.0.2.2:3000/api/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['user'] = 'test_user'
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
    } else {
      print('Image upload failed with status: ${response.statusCode}');
    }
  }
}
