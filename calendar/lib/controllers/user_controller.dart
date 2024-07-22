import 'package:calendar/Models%20/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../db/db_helper.dart'; 

class UserController extends GetxController {

  // Generate a unique ID
  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
  var user = User(id: '', name: '', email: '', token: '').obs;

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/login'),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      User loggedInUser = User.fromJson(json.decode(response.body));
      user.value = loggedInUser;

      // Insert user into local database
      await DBhelper.insertUser(loggedInUser);
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<void> registerUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/register'),
      body: {'id': generateUniqueId(),'name': name, 'email': email, 'password': password},
    );
    if (response.statusCode == 201) {
      // Handle successful registration if necessary
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/send-otp'),
      body: {'email': email},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP');
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/verify-otp'),
      body: {'email': email, 'otp': otp},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP');
    }
  }

  Future<void> logoutUser() async {
    // Remove user from local database
    await DBhelper.deleteUser(user.value.id!);
    user.value = User(id: '', name: '', email: '', token: '');
  }

  Future<void> fetchUserFromDb() async {
    List<User> users = await DBhelper.queryUsers();
    if (users.isNotEmpty) {
      user.value = users.first;
    }
  }
}
