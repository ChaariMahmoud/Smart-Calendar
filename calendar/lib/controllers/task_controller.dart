import 'package:calendar/Models%20/task.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    if (task == null) {
      print("Task is null");
      return Future.error("Task is null");
    }

    print("Task is not null, proceeding to insert");
    return await DBhelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBhelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete (Task task){
    DBhelper.delete(task);
  }

  Future<int> updateTask(Task task) async {
    return await DBhelper.update(task);
  }
}
