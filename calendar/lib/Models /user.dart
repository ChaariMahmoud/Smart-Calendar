import 'package:uuid/uuid.dart';

class User {
 String? id;
  String name;
  String email;
  String token;

  User({
    this.id, 
    required this.name, 
    required this.email,
     required this.token}){
    id ??= Uuid().v4(); // Generate a unique ID if null
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
