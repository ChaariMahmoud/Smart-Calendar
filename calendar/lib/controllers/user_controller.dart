// ignore_for_file: avoid_print

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

  var user = User(userId: '', name: '', email: '', token: '').obs;

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/login'),
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        User loggedInUser = User.fromJson(json.decode(response.body));
        user.value = loggedInUser;

        // Insert user into local database
        await DBhelper.insertUser(loggedInUser);

        print('User logged in successfully: ${user.value}');
      } else {
        print('Login failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to log in');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<void> registerUser(String userId,String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/register'),
        body: {'userId': userId, 'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        print('User registered successfully');
      } else {
        print('Registration failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/send-otp'),
        body: {'email': email},
      );
      if (response.statusCode != 200) {
        print('OTP send failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to send OTP');
      } else {
        print('OTP sent successfully');
      }
    } catch (e) {
      print('Error during OTP send: $e');
      rethrow;
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/verify-otp'),
        body: {'email': email, 'otp': otp},
      );
      if (response.statusCode != 200) {
        print('OTP verification failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to verify OTP');
      } else {
        print('OTP verified successfully');
      }
    } catch (e) {
      print('Error during OTP verification: $e');
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    try {
      // Remove user from local database
      await DBhelper.deleteUser(user.value.userId!);
      user.value = User(userId: '', name: '', email: '', token: '');
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  Future<void> fetchUserFromDb() async {
    try {
      List<User> users = await DBhelper.queryUsers();
      if (users.isNotEmpty) {
        user.value = users.first;
        print('User fetched from DB: ${user.value}');
      }
    } catch (e) {
      print('Error fetching user from DB: $e');
      rethrow;
    }
  }
}
