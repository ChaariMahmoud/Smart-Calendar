
import 'package:calendar/controllers/user_controller.dart';
import 'package:calendar/ui/new_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyOtpPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final TextEditingController otpController = TextEditingController();
  final String email;

  VerifyOtpPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify OTP for Your Email',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.security),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                try {
                  await userController.verifyOtp(email, otpController.text);
                  Get.snackbar('Success', 'OTP verification successful', snackPosition: SnackPosition.BOTTOM);
                  // Navigate to the next page after successful OTP verification
                  Get.to(SetNewPasswordPage(email: email,));
                } catch (e) {
                  Get.snackbar('OTP Verification Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
                  //sleep(Durations.long1);
                  //Get.to(LoginPage());
                }
              },
              child: const Text('Verify OTP', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
