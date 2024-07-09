import 'package:calendar/Models%20/task.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{

  var taskList = <Task>[].obs ;

  Future<int> addTask ({Task? task})async {
    return await DBhelper.insert(task) ;
  }

  void getTasks() async {
    List <Map<String,dynamic>> tasks = await DBhelper.querry();
    taskList.assignAll(tasks.map((data)=>Task.fromJson(data)).toList());
  }
}