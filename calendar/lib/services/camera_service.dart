import 'dart:convert';
import 'dart:io';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/core/config.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
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
    String token = loggedInUser!.token!;
    String userId = loggedInUser.userId!;

    // Read the image file
    final imageBytes = await image.readAsBytes();
    // Decode the image to be processed
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      print('Failed to decode image.');
      return null;
    }

    // Resize the image while maintaining the aspect ratio
    img.Image resizedImage = img.copyResize(originalImage, width: 800);

    // Encode the image to JPEG with higher quality
    List<int> compressedImageBytes = img.encodeJpg(resizedImage, quality: 75);
    String base64Image = 'data:image/jpeg;base64,' + base64Encode(compressedImageBytes);

    final uri = Uri.parse('${Config.baseUrl}/api/photo/upload');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'taskId': taskId,
        'userId': userId,
        'action': action,
        'imageData': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
      return 'Image uploaded successfully.';
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }
}
