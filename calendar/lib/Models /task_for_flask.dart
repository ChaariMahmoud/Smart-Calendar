import 'package:uuid/uuid.dart';

class TaskFlask {
  String? id;
  String title;
  String note;
  String type;
  String date;
  String beginTime;
  String endTime;
  int priority;
  int difficulty;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;
  int color;
  double successPercentage;
  List<String> preferredTimes;

  TaskFlask({
    this.id,
    required this.title,
    required this.note,
    required this.type,
    required this.date,
    required this.beginTime,
    required this.endTime,
    required this.priority,
    required this.difficulty,
    this.userId = "",
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.color,
    required this.successPercentage,
    required this.preferredTimes
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now() {
    id ??= Uuid().v4(); // Generate a unique ID if null
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'type': type,
      'date': date,
      'beginTime': beginTime,
      'endTime': endTime,
      'priority': priority,
      'difficulty': difficulty,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'color': color,
      'successPercentage': successPercentage,
      'preferredTimes' :preferredTimes
    };
  }

  
}