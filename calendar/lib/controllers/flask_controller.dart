import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class FlaskController extends GetxController{
  Future<void> callFlaskAPI(String userId) async {
  final url = 'http://your-flask-api-url/endpoint'; // Replace with your Flask API URL
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userId': userId,
    }),
  );

  if (response.statusCode == 200) {
    print("Flask API called successfully");
  } else {
    print("Failed to call Flask API");
  }
}
}