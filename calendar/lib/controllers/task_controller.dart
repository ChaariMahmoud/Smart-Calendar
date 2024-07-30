// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:calendar/Models%20/task.dart';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<String> getToken () async {
        User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
      return token ;
  }

  // Generate a unique ID
  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  Future<int> addTask({Task? task}) async {
    if (task == null) {
      print("Task is null");
      return Future.error("Task is null");
    }

    // Assign a unique ID if the task doesn't have one
    task.id = generateUniqueId();
    print("Task is not null, proceeding to insert");
    return await DBhelper.insert(task);
  }
  
   Future<Task?> getLocalTaskById(String? id) async {
    if (id == null) return null;
    List<Map<String, dynamic>> result = await DBhelper.query();
    var taskMap = result.firstWhere((task) => Task.fromJson(task).id == id, orElse: () => {});
    return taskMap.isNotEmpty ? Task.fromJson(taskMap) : null;
  }
  
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBhelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBhelper.delete(task);
  }

  Future<int> updateTask(Task task) async {
    return await DBhelper.update(task);
  }

  Future<void> fetchTasksFromBackend() async {
     User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/tasks/tasks'),        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},);

    if (response.statusCode == 200) {
      List<dynamic> taskData = json.decode(response.body);
      List<Task> tasks = Task.listFromJson(taskData);

      for (Task task in tasks) {
        if (!await _taskExistsInLocalDb(task.id)) {
          await DBhelper.insert(task);
        }
      }

      getTasks(); 
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> pushLocalTasksToBackend() async {
    List<Map<String, dynamic>> localTasks = await DBhelper.query();
    for (var taskMap in localTasks) {
      Task task = Task.fromJson(taskMap);
      if (!await _taskExistsInBackend(task.id!)) {
        await pushTaskToBackend(task);
      }
    }
  }

  Future<void> synchronizeTasks() async {
    await fetchTasksFromBackend();
    await pushLocalTasksToBackend();
    getTasks(); // Refresh the local task list
  }

  Future<void> pushTaskToBackend(Task task) async {
         User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/tasks/tasks'),
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
        body: json.encode(task.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 201) {
        //final Map<String, dynamic> responseData = jsonDecode(response.body);
        // task.id = responseData['_id']; // Set the generated ID from the server if necessary
        print('Task added successfully with ID: ${task.id}');
      } else {
        throw Exception('Failed to push task to backend: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }

  Future<void> updateTaskInBackend(Task task) async {
         User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/tasks/tasks/${task.id}'),
                headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
        body: json.encode(task.toJson()),
      );

      print('PUT request URL: ${response.request!.url}');
      print('PUT request headers: ${response.request!.headers}');
      print('PUT response status code: ${response.statusCode}');
      print('PUT response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update task in backend: ${response.body}');
      }
    } catch (e) {
      print('Exception during PUT request: $e');
      rethrow; 
    }
  }

  Future<void> deleteTaskFromBackend(String id) async {
         User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/tasks/tasks/$id',),
                headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
      );

      print('DELETE request URL: ${response.request!.url}');
      print('DELETE request headers: ${response.request!.headers}');
      print('DELETE response status code: ${response.statusCode}');
      print('DELETE response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task from backend: ${response.body}');
      }
    } catch (e) {
      print('Exception during DELETE request: $e');
      rethrow; 
    }
  }

  Future<bool> _taskExistsInLocalDb(String? id) async {
    if (id == null) return false;
    List<Map<String, dynamic>> result = await DBhelper.query();
    return result.any((taskMap) => Task.fromJson(taskMap).id == id);
  }

  Future<bool> _taskExistsInBackend(String id) async {
         User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/tasks/tasks/$id')  ,    
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},);
    return response.statusCode == 200;
  }

Future<List<Task>> getPreviousDayTasks() async {
  List<Map<String, dynamic>> tasks = await DBhelper.query();
  DateTime now = DateTime.now();
  DateTime startOfToday = DateTime(now.year, now.month, now.day);
  DateTime startOfYesterday = startOfToday.subtract(const Duration(days: 1));

  // List of possible date formats
  final List<DateFormat> dateFormats = [
    DateFormat('yyyy-MM-dd'),
    DateFormat('M/d/yyyy'),
    DateFormat('MM/dd/yyyy'),
    DateFormat('yyyy-MM-dd HH:mm:ss'),
    // Add more formats as needed
  ];

  return tasks
      .map((data) => Task.fromJson(data))
      .where((task) {
        DateTime? taskDate;
        for (var format in dateFormats) {
          try {
            taskDate = format.parse(task.date);
            break; // Exit loop if parsing is successful
          } catch (e) {
            // Continue with next format
          }
        }

        if (taskDate == null) {
          // Handle case where no format could parse the date
          return false;
        }

        return taskDate.isBefore(startOfToday) && taskDate.isAfter(startOfYesterday);
      })
      .toList();
}

  Future<void> deletePreviousDayTasks() async {
    List<Task> previousDayTasks = await getPreviousDayTasks();

    for (Task task in previousDayTasks) {
      await DBhelper.delete(task);
    }

    // Refresh the local task list after deletion
    getTasks();
  }

  void deleteLocalPreviousDayTasks() async {
    await deletePreviousDayTasks();
  }
}