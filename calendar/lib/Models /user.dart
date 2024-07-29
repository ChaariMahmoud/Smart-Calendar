import 'package:uuid/uuid.dart';

class User {
 String userId = Uuid().v4();
  String name;
  String email;
  String token;

  User({
    required this.userId, 
    required this.name, 
    required this.email,
     required this.token}){
    //userId ??= Uuid().v4(); 
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
