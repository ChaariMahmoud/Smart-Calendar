// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:calendar/Models%20/task.dart';
import 'package:calendar/Models%20/task_for_flask.dart';
import 'package:calendar/Models%20/user.dart';
import 'package:calendar/controllers/add_task_controller.dart';
import 'package:calendar/controllers/flask_ml_controller.dart';
import 'package:calendar/controllers/task_controller.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:calendar/services/camera_service.dart';
import 'package:calendar/ui/home_page.dart';
import 'package:calendar/ui/theme.dart';
import 'package:calendar/ui/widgets/button.dart';
import 'package:calendar/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
//import 'package:calendar/controllers/flask_controller.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String taskId =const Uuid().v4();
   final cameraService = CameraService();
   DateTime _selectedDate = DateTime.now() ;
   String _endTime = "11:59 PM";
   String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
   int _selectedDifficulty = 1 ;
   List<int> difficultyList =[
    1,
    2,
    3,
    4,
    5
   ];

   //String _selectedTimeOfDay = "Morning" ;
   List<String> TimeOfDayList =[
    "Morning",
    "Afternoon",
    "Evening",
    "Night",
   ];



   int _selectedColor=0;
   //double _successPercentage = 50.0;
    int _selectedPriority = 1;
    final List<bool> _isSelected = List.generate(5, (index) => index == 0) ;
    final TextEditingController _titleController = TextEditingController() ;
    final TextEditingController _noteController = TextEditingController() ;
    final TextEditingController _typeController = TextEditingController() ;
    final TaskController _taskController = Get.put(TaskController());
    final FlaskMlController _flaskController = Get.put(FlaskMlController());
    //bool _autoSelectTime = false ;
    final AddTaskController _addTaskController = Get.put(AddTaskController());
    DateTime _startSelectedDate = DateTime.now() ;
    DateTime _endSelectedDate = DateTime.now() ;
      List<bool> _preferredTimesSelected = List.generate(4, (index) => false);
  List<String> _preferredTimesOptions = ["Morning", "Afternoon", "Evening", "Night"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: _appBar(context),
      body: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.only(left: 15 , right: 15,bottom: 20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task" ,
              style: headingStyle,),
               MyInputField(title: "Title",hint: "Enter title here",controller: _titleController,),
               MyInputField(title: "Note",hint: "Enter note here",controller: _noteController,),
               MyInputField(title: "Type",hint: "Enter type here",controller: _typeController,),
              Obx(() => SwitchListTile(
                    title: Text(
                      "Auto Select Time with AI",
                      style: titleStyle,
                    ),
                    value: _addTaskController.autoSelectTime.value,
                    onChanged: (bool value) {
                      _addTaskController.toggleAutoSelectTime();
                    },
                    activeColor: primaryClr,
                  )),
              // Conditionally show the date and time input fields
              Obx(() {
                if (!_addTaskController.autoSelectTime.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyInputField(
                        title: "Date",
                        hint: DateFormat.yMMMMd().format(_selectedDate),
                        widget: IconButton(
                          icon: const Icon(Icons.calendar_today_outlined),
                          onPressed: () {
                            _getDateFromUser(dateType: 'selected');
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyInputField(
                              title: "Start Time",
                              hint: _startTime,
                              widget: IconButton(
                                icon: const Icon(Icons.access_time_rounded),
                                onPressed: () {
                                  _getTimeFromUser(isStartTime: true);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MyInputField(
                              title: "End Time",
                              hint: _endTime,
                              widget: IconButton(
                                icon: const Icon(Icons.access_time_rounded),
                                onPressed: () {
                                  _getTimeFromUser(isStartTime: false);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyInputField(
                    title: "From",
                    hint: DateFormat.yMMMMd().format(_startSelectedDate),
                    widget: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: () {
                        _getDateFromUser(dateType: 'start');
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyInputField(
                    title: "To",
                    hint: DateFormat.yMMMMd().format(_endSelectedDate),
                    widget: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: () {
                        _getDateFromUser(dateType: 'end');
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),
            _buildPreferredTimes()
             
          ],
        ),
      ],
    );
                }
              }),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Difficulty",
                      style: titleStyle,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 15),
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          iconSize: 30,
                          elevation: 5,
                          style: subTitleStyle,
                          items: difficultyList.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedDifficulty = newValue!;
                            });
                          },
                          value: _selectedDifficulty,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

 MyInputField(
  title: "Priority",
  hint: "$_selectedPriority",
  widget: ToggleButtons(
    isSelected: _isSelected,
    onPressed: (int index) {
      setState(() {
        for (int i = 0; i < _isSelected.length; i++) {
          _isSelected[i] = i == index;
        }
        _selectedPriority = index + 1;
      });
    },
    children: List<Widget>.generate(5, (int index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text((index + 1).toString()),
      );
    }),
  ),
),


const SizedBox(height: 15,),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    _colorPalette (), 
    Column(
      children: [
        const SizedBox(height: 12),
        MyButton(label: "Add Task", onTap: () => _validateData()),
      ],
    )
  ],
)              
            ],
          ),
        ),
      ),
    );
  }



  //Refactor

AppBar _appBar(BuildContext context) {
  return AppBar(
    //elevation: 10,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, size: 25),
      onPressed: () {
        Get.to(HomePage());
      },
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.camera_alt_outlined, size: 35),
        onPressed: () async {
          final ImageSource? source = await showDialog<ImageSource>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select Image Source'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Camera'),
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_album),
                      title: const Text('Gallery'),
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                  ],
                ),
              );
            },
          );

          if (source != null) {
            bool fromGallery = source == ImageSource.gallery;
            File? image = await cameraService.getImage(fromGallery: fromGallery, context: context);
            if (image != null) {
              String? imageUrl = await cameraService.uploadImage(
                image,
                taskId, // This should be the actual taskId after the task is created
                "add",
              );
              if (imageUrl != null) {
                print("Image uploaded: $imageUrl");
                Get.snackbar(
                  "Success",
                  "Image uploaded successfully!",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                );
              } else {
                Get.snackbar(
                  "Error",
                  "Image upload failed!",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                );
              }
            }
          }
        },
      ),
      const SizedBox(width: 20),
    ],
  );
}


_getDateFromUser({required String dateType}) async {
  DateTime? pickerDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );

  if (pickerDate != null) {
    setState(() {
      if (dateType == 'selected') {
        _selectedDate = pickerDate;
      } else if (dateType == 'start') {
        _startSelectedDate = pickerDate;
      } else if (dateType == 'end') {
        _endSelectedDate = pickerDate;
      }
    });
  }
}


_getTimeFromUser({required bool isStartTime}) async {
  var pickedTime = await _showTimePicker();
  String _formatedTime =pickedTime.format(context);
  if (isStartTime ==true){
    setState(() {
      _startTime = _formatedTime;
    });
  } else {
      setState(() {
       _endTime = _formatedTime ;
      });
  }
}

_showTimePicker(){
  return showTimePicker(context: context,
   initialTime:  TimeOfDay(
    hour: int.parse(_startTime.split(":")[0]),
    minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
   initialEntryMode: TimePickerEntryMode.input 
   );
}


_colorPalette(){
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
        style: titleStyle,),
        const SizedBox(height: 10,),
        Wrap(
          children: List<Widget>.generate(3, (int index){
            return GestureDetector(
              onTap: (){
                 setState(() {
                   _selectedColor = index ;
                 });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(radius: 15,backgroundColor: index==0?bluishClr:index==1?pinkClr:yellowClr,
                child: _selectedColor ==index ?const Icon(Icons.done,color: Colors.white,size: 15,):Container()),
              ),
            );
          },)

          
        )
      ],
    ) ;
}


  _validateData() {
    if (_titleController.text.isNotEmpty &&
        _noteController.text.isNotEmpty &&
        _typeController.text.isNotEmpty) {
      if (_addTaskController.autoSelectTime.value) {
        _sendTaskToFlask();
        Get.to(const HomePage());
      } else {
        _addtaskToDb();
        Get.to(const HomePage());
      }
    } else if (_titleController.text.isEmpty ||
        _noteController.text.isEmpty ||
        _typeController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }


_addtaskToDb() async {
  

  // Print values before creating the Task object
  print("Title: ${_titleController.text}");
  print("Note: ${_noteController.text}");
  print("Type: ${_typeController.text}");
  print("Date: ${DateFormat.yMd().format(_selectedDate)}");
  print("Start Time: $_startTime");
  print("End Time: $_endTime");
  print("Difficulty: $_selectedDifficulty");
  print("Priority: $_selectedPriority");
  print("Color: $_selectedColor");
    User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String userId = loggedInUser!.userId!;

  // Create a Task object
  Task newTask = Task(
    id: taskId,
    title: _titleController.text,
    note: _noteController.text,
    type: _typeController.text,
    date: DateFormat.yMd().format(_selectedDate),
    beginTime: _startTime,
    endTime: _endTime,
    successPercentage: 0.0,
    difficulty: _selectedDifficulty,
    priority: _selectedPriority,
    userId: userId, //mapping here
    color: _selectedColor,
  );

  print("AddTaskToDb: Task details before insertion: ${newTask.toJson()}");

  // Add task to the database
  int value = await _taskController.addTask(task: newTask);
  print("AddTaskToDb: My id is $value");

  // Push the new task to the backend
  await _taskController.pushTaskToBackend(newTask);

  // Synchronize tasks after adding
  await _taskController.synchronizeTasks();
}

  _sendTaskToFlask() async {
    User? loggedInUser = await DBhelper.getLoggedInUser();
    String userId = loggedInUser!.userId!;

    TaskFlask task = TaskFlask(
      id: taskId,
      title: _titleController.text,
      note: _noteController.text,
      type: _typeController.text,
      date: "${DateFormat.yMd().format(_startSelectedDate)}  +  ${DateFormat.yMd().format(_endSelectedDate)}",
      beginTime: _startTime,
      endTime: _endTime,
      successPercentage: 0.0,
      difficulty: _selectedDifficulty,
      priority: _selectedPriority,
      userId: userId,
      color: _selectedColor,
      
      preferredTimes: _preferredTimesOptions
            .asMap()
            .entries
            .where((entry) => _preferredTimesSelected[entry.key])
            .map((entry) => entry.value)
            .toList(),
    );

    print("Sending task to Flask API: ${task.toJson()}");
    await _flaskController.autoSelectTimeAndAddTask(task);
  }


   Widget _buildPreferredTimes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Preferred Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
        Column(
          children: _preferredTimesOptions
              .asMap()
              .entries
              .map((entry) => SizedBox(
                    width: double.infinity,
                    child: CheckboxListTile(
                      title: Text(entry.value),
                      value: _preferredTimesSelected[entry.key],
                      onChanged: (bool? value) {
                        setState(() {
                          _preferredTimesSelected[entry.key] = value ?? false;
                        });
                      },
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

}