import 'package:calendar/Models%20/survey_model.dart';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SurveyController {

  Future<bool> submitSurvey(Survey survey) async {
    User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
      print(token);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/surveys/surveys'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
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
