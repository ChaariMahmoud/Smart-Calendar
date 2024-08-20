import 'package:http/http.dart' as http;
import 'dart:convert';

class FlaskController {
  Future<void> callFlaskAPI(String imageBase64, String action, String userId, {String? taskId}) async {
    final url = 'http://192.168.1.123:5000/api/extract_tasks';

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
    } else {
      print('Failed to process task: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
