import 'dart:convert';
import 'dart:io';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/controllers/flask_controller.dart';
import 'package:calendar/core/config.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CameraService {
  final picker = ImagePicker();
  final FlaskController flaskController = FlaskController();

  Future<File?> getImage({bool fromGallery = false, BuildContext? context}) async {
    final pickedFile = fromGallery
        ? await picker.pickImage(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Crop the image using image_cropper
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,

        //cropStyle: CropStyle.rectangle, // Optional: CropStyle.circle for circular crops
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0), // Set your preferred aspect ratio
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        // Convert CroppedFile to File
        return File(croppedFile.path);
      } else {
        print('Image cropping canceled.');
        return null;  // User canceled cropping
      }
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
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'taskId': taskId,
        'userId': userId,
        'action': action,
        'imageData': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');

      // Log before calling Flask API
      print('Calling Flask API with action: $action, userId: $userId, taskId: $taskId');

      // Call Flask API after successful upload
      await flaskController.callFlaskAPI(base64Image, action, userId, taskId: taskId);

      return 'Image uploaded successfully.';
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }
}
