import 'dart:async';

import 'package:calendar/services/notification_services.dart';
import 'package:calendar/services/theme_service.dart';
import 'package:calendar/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentDate = DateFormat.yMMMMd().format(DateTime.now());
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateDate());
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentDate, style: subHeadingStyle,),
                const Text("Today"),
              ],
            ),
          )
        ],
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
          size: 20,
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
}
