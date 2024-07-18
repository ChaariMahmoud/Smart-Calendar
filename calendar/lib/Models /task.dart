import 'dart:convert';

class Task {
  int? id;
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

  Task({
    this.id,
    required this.title,
    required this.note,
    required this.type,
    required this.date,
    required this.beginTime,
    required this.endTime,
    required this.priority,
    required this.difficulty,
    this.userId = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.color,
    required this.successPercentage,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      type: json['type'],
      date: json['date'],
      beginTime: json['beginTime'],
      endTime: json['endTime'],
      priority: json['priority'],
      difficulty: json['difficulty'],
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      successPercentage: json['successPercentage'].toDouble(),
      color: json['color'] ?? 0,
    );
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
    };
  }
  static List<Task> listFromJson(List<dynamic> json) {
    return json.map((value) => Task.fromJson(value)).toList();
  }

  static String listToJson(List<Task> list) {
    return json.encode(list.map((task) => task.toJson()).toList());
  }

  Task copyWith({
    int? id,
    String? title,
    String? note,
    String? type,
    String? date,
    String? beginTime,
    String? endTime,
    int? priority,
    int? difficulty,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? color,
    double? successPercentage,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      type: type ?? this.type,
      date: date ?? this.date,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      difficulty: difficulty ?? this.difficulty,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      successPercentage: successPercentage ?? this.successPercentage,
    );
  }
}
