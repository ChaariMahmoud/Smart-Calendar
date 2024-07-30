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

  var user = User( userId : '',name:'', email: '', token: '').obs;

  Future<void> loginUser(String email, String password) async {
  print('Attempting to log in user with email: $email');
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Login response status code: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      
      // Extract fields from the response
      String? token = responseData['token'];
      String? name = responseData['name'];
      String? email = responseData['email'];
      String? userId = responseData['userId'];

      // Validate required fields
      if (token != null && userId != null) {
        // Check if user already exists in local database
        User? existingUser = await DBhelper.getUserById(userId);

        if (existingUser == null) {
          // Create a User object using the data from the response
          User loggedInUser = User(
            userId: userId,
            name: name,
            email: email,
            token: token,
          );

          // Insert user into local database
          await DBhelper.insertUser(loggedInUser);

          print('User logged in and inserted into local database: ${loggedInUser}');
        } else {
          // Update existing user data if needed
          existingUser.token = token; // Update token or other fields as necessary
          await DBhelper.updateUser(existingUser);

          print('User logged in and updated in local database: ${existingUser}');
        }

        user.value = existingUser ?? User(
          userId: userId,
          name: name,
          email: email,
          token: token,
        );
      } else {
        print('Incomplete response data');
        throw Exception('Failed to log in: Incomplete response data');
      }
    } else {
      print('Login failed with status: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to log in');
    }
  } catch (e) {
    print('Error during login: $e');
    rethrow;
  }
}



  Future<void> registerUser(String userId, String name, String email, String password) async {
    print('Attempting to register user with email: $email');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/register'),
        headers: {
        'Content-Type': 'application/json',
      },
        body: json.encode({'userId': userId, 'name': name, 'email': email, 'password': password}),
      );
      print('Registration response status code: ${response.statusCode}');
      print('Registration response body: ${response.body}');
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
    print('Attempting to send OTP to email: $email');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/send-otp'),
         headers: {
        'Content-Type': 'application/json',
      },
        body: jsonEncode({'email': email}) ,
      );
      print('Send OTP response status code: ${response.statusCode}');
      print('Send OTP response body: ${response.body}');
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
    print('Attempting to verify OTP for email: $email');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/verify-otp'),
        headers: {
        'Content-Type': 'application/json',
      },
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      print('Verify OTP response status code: ${response.statusCode}');
      print('Verify OTP response body: ${response.body}');
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
    print('Attempting to log out user with ID: ${user.value.userId}');
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
    print('Attempting to fetch user from local database');
    try {
      List<User> users = await DBhelper.queryUsers();
      print('Fetched users: $users');
      if (users.isNotEmpty) {
        user.value = users.first;
        print('User fetched from DB: ${user.value}');
      } else {
        print('No users found in local database');
      }
    } catch (e) {
      print('Error fetching user from DB: $e');
      rethrow;
    }
  }

   Future<void> setNewPassword(String email, String newPassword) async {
    print('Attempting to set new password for email: $email');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/reset-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
      );
      print('Set new password response status code: ${response.statusCode}');
      print('Set new password response body: ${response.body}');
      if (response.statusCode != 200) {
        print('Set new password failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to set new password');
      } else {
        print('New password set successfully');
      }
    } catch (e) {
      print('Error during set new password: $e');
      rethrow;
    }
  }
}
