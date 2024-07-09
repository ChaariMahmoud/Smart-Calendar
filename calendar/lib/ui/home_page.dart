// ignore_for_file: prefer_const_constructors

import 'package:calendar/controllers/task_controller.dart';
import 'package:calendar/services/notification_services.dart';
import 'package:calendar/services/theme_service.dart';
import 'package:calendar/ui/add_task_page.dart';
import 'package:calendar/ui/theme.dart';
import 'package:calendar/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Color dateTextColor = Get.isDarkMode ? Colors.white : Colors.black;
  String currentDate = DateFormat.yMMMMd().format(DateTime.now());
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();

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
          children: [_addTaskBar(), 
                     _addDateBar(),
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
            _taskController.addTask();
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
          );
        },
      ),
    );
  }

  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_,index){
            print(_taskController.taskList.length);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 100,
            height: 50,
            color: Colors.red,
            child: Text(
              _taskController.taskList[index].title.toString(),
            ),


          ) ;
        });

      }),
    );
  }
}
