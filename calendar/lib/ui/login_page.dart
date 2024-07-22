import 'package:calendar/controllers/user_controller.dart';
import 'package:calendar/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await userController.loginUser(emailController.text, passwordController.text);
                  // Navigate to home page on successful login
                   Get.to(const HomePage());
                } catch (e) {
                  // Show error message
                  Get.snackbar('Login Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
