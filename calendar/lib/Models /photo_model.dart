import 'dart:convert';

class Photo {
  String? id;
  String taskId;
  String userId;
  String url;
  String action; // "add" or "update"
  DateTime createdAt;
  DateTime updatedAt;

  Photo({
    this.id,
    required this.taskId,
    required this.userId,
    required this.url,
    required this.action,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
  
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['_id'] ?? json['id'], // Handle both cases for ID
      taskId: json['taskId'],
      userId: json['userId'],
      url: json['url'],
      action: json['action'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'userId': userId,
      'url': url,
      'action': action,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static List<Photo> listFromJson(List<dynamic> json) {
    return json.map((value) => Photo.fromJson(value)).toList();
  }

  static String listToJson(List<Photo> list) {
    return json.encode(list.map((photo) => photo.toJson()).toList());
  }
}
