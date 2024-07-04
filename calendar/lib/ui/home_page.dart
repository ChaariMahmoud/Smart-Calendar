import 'dart:async';

import 'package:calendar/services/notification_services.dart';
import 'package:calendar/services/theme_service.dart';
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
  Color dateTextColor = Get.isDarkMode ? Colors.white : Colors.black;
  String currentDate = DateFormat.yMMMMd().format(DateTime.now());

  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateDate());
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  void _updateDate() {
    setState(() {
      currentDate = DateFormat.yMMMMd().format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentDate, style: subHeadingStyle,),
                      Text("Today",style:headingStyle),
                    ],
                  ),
                  const MyButton(label: "+ Add Task", onTap:null)
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12,left: 15),
              child: DatePicker(
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
                 dayTextStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
                 monthTextStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
            )
          ],
          
        ),
      ),
    );
  }

  AppBar _appBar() {
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
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 25,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
          maxRadius: 18,
        ),
        SizedBox(width: 20,)
      ],
    );
  }

///Refactor code 



}


//Get.isDarkMode ?Colors.black :Colors.white,