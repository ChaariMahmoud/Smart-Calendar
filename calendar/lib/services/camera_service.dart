// services/camera_service.dart

import 'dart:io';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    if (loggedInUser == null) {
      print('User not logged in.');
      return null;
    }

    String userId = loggedInUser.userId!;
    final uri = Uri.parse('http://10.0.2.2:3000/api/photos/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['taskId'] = taskId
      ..fields['userId'] = userId
      ..fields['action'] = action
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      print('Image uploaded successfully.');
      return jsonResponse['url'];
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      return null;
    }
  }
}
