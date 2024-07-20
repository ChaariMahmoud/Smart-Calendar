import 'package:calendar/Models%20/survey_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SurveyController {
  Future<bool> submitSurvey(Survey survey) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/surveys'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(survey.toJson()),
    );

    if (response.statusCode == 201) {
      print('Survey added successfully with ID: ${survey.userId}');
    } else {
       throw Exception('Failed to post survey in backend: ${response.body}');
    }
    return response.statusCode == 201;
  }
}
