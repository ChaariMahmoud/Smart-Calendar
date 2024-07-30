import 'package:uuid/uuid.dart';

class User {
  String? userId; // Corresponds to userId in the backend
  String? name; // Corresponds to name in the backend
  String? email; // Corresponds to email in the backend
  String? token; // Corresponds to jwtToken in the backend
  String? photo;
  User({
    this.userId,
    this.name,
    this.email,
    this.token,
    this.photo
  }) {
    userId ??= const Uuid().v4();
  }

  // From JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      photo: json['photo']?? '',
    );
  }

  // From User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'token': token,
      'photo': photo,
    };
  }
}
