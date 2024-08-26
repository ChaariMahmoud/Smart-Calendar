import 'dart:convert';
import 'dart:io';
import 'package:calendar/controllers/user_controller.dart';
import 'package:calendar/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ProfilePage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Obx(() {
        // Ensure user data is updated
        final user = userController.user.value;
        nameController.text = user.name ?? '';
        emailController.text = user.email ?? '';
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _getUserImage(user.photo),
                    child: user.photo == null || user.photo!.isEmpty
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _updateProfile(),
                child: const Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  ImageProvider _getUserImage(String? photo) {
    if (photo == null ) {
      return const AssetImage('images/profile.png');
    } else if (photo.startsWith('data:image')) {
      return MemoryImage(base64Decode(photo.split(',').last));
    } else {
      return NetworkImage(photo);
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      // Read the image file
      final imageBytes = await File(pickedFile.path).readAsBytes();

      // Decode the image to be processed
      img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        print('Failed to decode image.');
        return;
      }

      // Resize the image while maintaining the aspect ratio
      img.Image resizedImage = img.copyResize(originalImage, width: 800);

      // Encode the image to JPEG with high quality
      List<int> compressedImageBytes = img.encodeJpg(resizedImage, quality: 75);
      String base64Image = 'data:image/jpeg;base64,' + base64Encode(compressedImageBytes);

      // Update user profile with the compressed image
      userController.updateUserProfile(photo: base64Image);
    } else {
      print('No image selected.');
    }
  }

  void _updateProfile() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    }
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      Get.snackbar('Error', 'Enter a valid email');
      return;
    }

    userController.updateUserProfile(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text.isNotEmpty ? passwordController.text : null,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    userController.logoutUser();
    Get.offAll(LoginPage()); // Redirect to login page
  }
}
