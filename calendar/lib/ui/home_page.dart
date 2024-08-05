import 'dart:io';

import 'package:calendar/Models%20/task.dart';
import 'package:calendar/controllers/network_controller.dart';
import 'package:calendar/controllers/task_controller.dart';
import 'package:calendar/services/camera_service.dart';
import 'package:calendar/services/notification_services.dart';
import 'package:calendar/services/theme_service.dart';
import 'package:calendar/ui/add_task_page.dart';
import 'package:calendar/ui/edit_task_page.dart';
import 'package:calendar/ui/profile._page.dart';
import 'package:calendar/ui/theme.dart';
import 'package:calendar/ui/widgets/button.dart';
import 'package:calendar/ui/widgets/task_tile.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentDate = DateFormat.yMd().format(DateTime.now());
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  final NetworkController _networkController = Get.put(NetworkController());
   final cameraService = CameraService();
     String calendarId =const Uuid().v4();

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
    _taskController.synchronizeTasks();
    //_taskController.deleteLocalPreviousDayTasks();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Obx(() {
      // Check network status and show appropriate toast message
      if (!_networkController.isOnline.value) {
        showToast('You are offline', backgroundColor: Colors.red);
      } else {
        showToast('You are online', backgroundColor: Colors.green);
      }
      return const SizedBox.shrink(); // Return an empty widget as we use Toast
    }),

            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 12),
            _showTasks(),
        
          ],
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () async {File? image = await cameraService.getImage();
            if (image != null) {
              String? imageUrl = await cameraService.uploadImage(
                image,
                 calendarId, // This should be the actual taskId after the task is created
                "calendar",
              );
             if (imageUrl != null) {
                print("Image uploaded: $imageUrl");
                
                Get.snackbar(
                "Success",
                "Image uploaded successfully!",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 3),
                // Call the Flask API after the image is successfully uploaded
              // await _flaskController.callFlaskAPI( widget.task.id);
              );
            
              }else{
                 Get.snackbar(
                "Error",
                "Image upload failed!",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 3),
              );
              
              }
            }
          },
        backgroundColor: primaryClr,
        child: const Icon(Icons.camera_alt, size: 30), // Camera icon
      ),
    );
    
  }

  AppBar _appBar() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      elevation: 10,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Icon(
          isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 25,
        ),
      ),
      actions:   [
        GestureDetector(
          onTap: (){
            Get.to(ProfilePage());
          },
          child: const Icon(Icons.settings,size: 30,)
        ),

        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentDate,
                style: subHeadingStyle,
              ),
              Text("Today", style: headingStyle),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15),
      child: Builder(
        builder: (context) {
          bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return DatePicker(
            DateTime.now(),
            height: 90,
            width: 80,
            initialSelectedDate: DateTime.now().subtract(const Duration(days: 1)),
            selectionColor: primaryClr,
            selectedTextColor: Colors.white,
            dateTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
            dayTextStyle:
                TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            monthTextStyle:
                TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          );
        },
      ),
    );
  }

  Widget _showTasks() {
    return Expanded(
      child: Obx(() {
        List<Task> tasksForSelectedDate = _taskController.taskList.where((task) {
          DateTime taskDate = DateFormat.yMd().parse(task.date);
          return taskDate.isAtSameMomentAs(_selectedDate);
        }).toList();

        if (tasksForSelectedDate.isEmpty) {
          return const Center(child: Text("No tasks for this date"));
        }

        return ListView.builder(
          itemCount: tasksForSelectedDate.length,
          itemBuilder: (_, index) {
            Task task = tasksForSelectedDate[index];
            DateTime date;
            try {
              date = DateFormat.jm().parse(task.beginTime.toString());
            } catch (e) {
              date = DateFormat("HH:mm").parse(task.beginTime.toString());
            }

            var myTime = DateFormat("HH:mm").format(date);
            notifyHelper.scheduledNotification(
              int.parse(myTime.split(":")[0]),
              int.parse(myTime.split(":")[1]),
              task,
              TaskTile(task),
            );

            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, task);
                        },
                        child: TaskTile(task),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            _bottomSheetButton(
              label: "Update Task",
              clr: primaryClr,
              onTap: () {
                Get.back();
                Get.to(() => EditTaskPage(task: task));
                _taskController.getTasks();
              },
              isClosed: false,
              context: context,
            ),
            const SizedBox(height: 10),
            _bottomSheetButton(
              label: "Delete Task",
              clr: Colors.red[300]!,
              onTap: () async {
                _taskController.delete(task);
                _taskController.getTasks();
              await _taskController.deleteTaskFromBackend(task.id!);
              await _taskController.synchronizeTasks(); 
                Get.back();
              },
              isClosed: false,
              context: context,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              clr: Colors.red[300]!,
              onTap: () {
                Get.back();
              },
              isClosed: true,
              context: context,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClosed = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClosed == true ? Colors.transparent : clr,
          border: Border.all(
            width: 2,
            color: isClosed == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: isClosed
                ? titleStyle
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Function to show a toast message
void showToast(String message, {Color backgroundColor = Colors.black}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}
}