import 'dart:convert';

import 'package:calendar/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';



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
      ),
      body: Obx(() {
        nameController.text = userController.user.value.name ?? '';
        emailController.text = userController.user.value.email ?? '';
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pickImage(),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userController.user.value.photo != null
                      ? NetworkImage(userController.user.value.photo!)
                      : null,
                  child: userController.user.value.photo == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () => _updateProfile(),
                child: const Text('Update Profile'),
              ),
            ],
          ),
        );
            }),
    );
  }


  Future<void> _pickImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery , preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      String base64Image = base64Encode(await pickedFile.readAsBytes());
      userController.updateUserProfile(photo: base64Image);
    }
  }

  void _updateProfile() {
    userController.updateUserProfile(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text.isNotEmpty ? passwordController.text : null,
    );
  }
}
