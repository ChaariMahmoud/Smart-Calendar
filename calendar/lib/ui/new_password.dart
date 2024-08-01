import 'package:calendar/controllers/user_controller.dart';
import 'package:calendar/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetNewPasswordPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final String email;

  SetNewPasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set New Password', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Set Your New Password',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (passwordController.text == confirmPasswordController.text) {
                    try {
                      await userController.setNewPassword(email, passwordController.text);
                      Get.snackbar('Success', 'Password reset successful', snackPosition: SnackPosition.BOTTOM);
                      Get.offAll(LoginPage()); // Navigate to login page after password reset
                    } catch (e) {
                      Get.snackbar('Password Reset Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
                    }
                  } else {
                    Get.snackbar('Password Mismatch', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text('Set New Password', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
