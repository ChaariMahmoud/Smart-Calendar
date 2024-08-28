// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:calendar/Models%20/task.dart';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/core/config.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
      String userId = loggedInUser.userId!;
    final response = await http.get(Uri.parse('${Config.baseUrl}/api/tasks/tasks/user/$userId'),        headers: {
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
    await pushLocalTasksToBackend();
    await fetchTasksFromBackend();
    
     // Refresh the local task list
     //getTasks();
  }

  Future<void> pushTaskToBackend(Task task) async {
         User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String token = loggedInUser!.token!;
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/tasks/tasks'),
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
        Uri.parse('${Config.baseUrl}/api/tasks/tasks/${task.id}'),
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

  Future<void> deleteTaskFromBackend(Task task) async {
  // Retrieve the logged-in user and their token
  User? loggedInUser = await DBhelper.getLoggedInUser();
  String token = loggedInUser!.token!;

  try {
    // Make the DELETE request to the backend
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/tasks/tasks/${task.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('DELETE request URL: ${response.request!.url}');
    print('DELETE request headers: ${response.request!.headers}');
    print('DELETE response status code: ${response.statusCode}');
    print('DELETE response body: ${response.body}');

    // Check if the deletion was successful
    if (response.statusCode == 200) {
      // If successful, delete the task from the local database
      await DBhelper.delete(task);
      print('Task successfully deleted from backend and local database');
    } else {
      // If unsuccessful, throw an exception with the response body
      throw Exception('Failed to delete task from backend: ${response.body}');
    }
  } catch (e) {
    print('Exception during DELETE request: $e');
    // Handle any exceptions during the DELETE request
    rethrow; // Re-throw the exception if needed for further handling
  } finally {
    // Synchronize tasks by fetching the updated list
    getTasks();
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
    final response = await http.get(Uri.parse('${Config.baseUrl}/api/tasks/tasks/$id')  ,    
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},);
    return response.statusCode == 200;
  }
}