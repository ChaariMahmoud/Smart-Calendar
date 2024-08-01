// services/camera_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/core/config.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<String?> uploadImage(File image, String taskId, String action) async {
         User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
      String userId = loggedInUser.userId!;
    final bytes = await image.readAsBytes();
    final base64Image = 'data:image/${image.path.split('.').last};base64,' + base64Encode(bytes);

    final uri = Uri.parse('${Config.baseUrl}/api/photo/upload');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
      body: jsonEncode({
        'taskId': taskId,
        'userId': userId, // Replace with actual user ID
        'action': action,
        'imageData': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
      return 'Image uploaded successfully.';
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      return null;
    }
  }
}
