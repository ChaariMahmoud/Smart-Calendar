class Survey {
  String userId;
  String preferredWorkHours;
  List<String> activeDays;
  List<String> taskTypes;
  String mood;
  String feelings;
  double sleepHours;
  String wakeUpTime;

  Survey({
    required this.userId,
    required this.preferredWorkHours,
    required this.activeDays,
    required this.taskTypes,
    required this.mood,
    required this.feelings,
    required this.sleepHours,
    required this.wakeUpTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'preferredWorkHours': preferredWorkHours,
      'activeDays': activeDays,
      'taskTypes': taskTypes,
      'mood': mood,
      'feelings': feelings,
      'sleepHours': sleepHours,
      'wakeUpTime': wakeUpTime,
    };
  }
}
