// ignore_for_file: prefer_const_declarations

import 'package:calendar/controllers/task_controller.dart';
import 'package:calendar/core/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlaskOcrController {
   final TaskController _taskController = Get.put(TaskController());
  Future<void> callFlaskAPI(String imageBase64, String action, String userId, {String? taskId}) async {
    final url = '${Config.flaskUrl}:5001/api/extract_tasks';

    // Log before making the request
    print('Making request to Flask API');
    print('URL: $url');
    print('Payload: ${jsonEncode({
      'imageData': imageBase64,
      'action': action,
      'userId': userId,
      'taskId': taskId,
    })}');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'imageData': imageBase64,
        'action': action,
        'userId': userId,
        'taskId': taskId,
      }),
    ).timeout(Duration(seconds: 30), onTimeout: () {
      print('Request to Flask API timed out');
      return http.Response('Error', 408); // Return a request timeout error
    });

    // Log the response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Task processed successfully');
      _taskController.synchronizeTasks();
    } else {
      print('Failed to process task: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
