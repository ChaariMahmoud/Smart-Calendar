import 'package:calendar/Models%20/task.dart';
import 'package:calendar/core/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlaskMlController extends GetxController {

  Future<void> autoSelectTimeAndAddTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.flaskUrl}:5000/auto_select_time'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        jsonDecode(response.body);
        // Process the response if necessary
        print('Task added successfully with AI selected time.');
        Get.snackbar(
          "Success",
          "Task added successfully with AI selected time!",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to add task with AI selected time.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        "Error",
        "An error occurred while communicating with the Flask API.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
