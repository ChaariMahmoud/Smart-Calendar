// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:calendar/Models%20/task.dart';
import 'package:calendar/controllers/task_controller.dart';
import 'package:calendar/services/notification_services.dart';
import 'package:calendar/services/theme_service.dart';
import 'package:calendar/ui/add_task_page.dart';
import 'package:calendar/ui/edit_task_page.dart';
import 'package:calendar/ui/theme.dart';
import 'package:calendar/ui/widgets/button.dart';
import 'package:calendar/ui/widgets/task_tile.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  String currentDate = DateFormat.yMd().format(DateTime.now());
  DateTime _selectedDate =DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();

    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          children: [_addTaskBar(), 
                     _addDateBar(),
                      SizedBox(height: 12),
                     _showTasks(),
          ],
        ),
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
          notifyHelper.displayNotification(
              title: "Theme changed",
              body: Get.isDarkMode
                  ? "Light Theme Activated"
                  : "Dark Theme Activated");
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 25,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
          maxRadius: 18,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _addTaskBar() {
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
           MyButton(label: "+ Add Task", onTap: () async {
  
               await Get.to(()=> AddTaskPage()); 
               _taskController.getTasks();
               
            
           })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15),
      child: Builder(
        builder: (context) {
          bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return DatePicker(
            DateTime.now(),
            height: 90,
            width: 80,
            initialSelectedDate: DateTime.now(),
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
                    _selectedDate = date ;
                  });
                }
          );
        },
      ),
    );
  }

  _showTasks() {
  return Expanded(
    child: Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index) {
          Task task = _taskController.taskList[index];
          DateTime taskDate = DateFormat.yMd().parse(task.date);
          
          if (taskDate.isAtSameMomentAs(_selectedDate)) {
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showButtomSheet(context, task);
                        },
                        child: TaskTile(task),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      );
    }),
  );
}


   _showButtomSheet(BuildContext context, Task task){
      Get.bottomSheet(
        Container(
          padding: EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width,
          color: Get.isDarkMode?darkGreyClr:Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
                ),
              ),
               Spacer(),
              _buttomSheetButton(label: "Update task ",clr: primaryClr ,onTap: () {
                Get.back();
                Get.to(() => EditTaskPage(task: task));
                _taskController.getTasks();
              },isColsed: false, context: context),
              SizedBox(height: 10,),
              _buttomSheetButton(label: "Delete task ",clr: Colors.red[300]! ,onTap: () {
                _taskController.delete(task);
                _taskController.getTasks();
                Get.back();
              },isColsed: false, context: context),
              SizedBox(height: 20,),
              _buttomSheetButton(label: " Close ",clr: Colors.red[300]! ,onTap: () {
                Get.back();
              },isColsed: true, context: context),
              SizedBox(height: 10)
            ],
          ),
        )
      );
   }

  _buttomSheetButton ({
    required String label ,
    required Function ()? onTap,
    required Color clr ,
    bool isColsed =false ,
    required BuildContext context ,
  }){
       return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width*0.9,
          decoration: BoxDecoration(
            color: isColsed==true?Colors.transparent:clr,
            border :Border.all(
              width: 2,
              color: isColsed==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: isColsed?titleStyle:titleStyle.copyWith(color: Colors.white),
              
            ),
          ),
        ),
       );
  }
}
