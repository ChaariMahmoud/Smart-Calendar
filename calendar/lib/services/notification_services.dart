// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_new

import 'package:calendar/Models%20/task.dart';
import 'package:calendar/ui/notified_page.dart';
import 'package:calendar/ui/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;


class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  final List<DateFormat> dateFormats = [
    DateFormat('yyyy-MM-dd'),
    DateFormat('M/d/yyyy'),
    DateFormat('MM/dd/yyyy'),
    DateFormat('yyyy-MM-dd HH:mm:ss'),
  ];

  Future<void> initializeNotification() async {
    await _configureLocalTimezone();

    await requestNotificationPermissions(); // Request permissions before initializing

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings( 
            iOS: initializationSettingsIOS,
            android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    await createNotificationChannel();
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'ai_calendar_channel', // id
      'AI Calendar', // name
      description: 'AI Calendar Notifications', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestNotificationPermissions() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text("Welcome"));
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => NotifiedPage(label: payload!));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduledNotification(int hour, int minutes, Task task, TaskTile taskTile) async {
    int taskId = task.id.hashCode;
    DateTime taskDate = DateTime.now();
    for (var format in dateFormats) {
      try {
        taskDate = format.parse(task.date);
        break;
      } catch (e) {
        // Continue with next format
      }
    }
    tz.TZDateTime scheduleDate = _convertDateTime(taskDate, hour, minutes);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      taskId,
      task.title,
      task.note,
      scheduleDate,
      const NotificationDetails(
        android: AndroidNotificationDetails('your_channel_id', 'your_channel_name'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|${task.note}|${task.type}|${task.difficulty.toString()}|${task.priority.toString()}|",
    );
  }

  Future<void> displayNotification({required String title, required String body}) async {
    print("Displaying notification: $title, $body");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'ai_calendar_channel', 'AI Calendar',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: null,
    );
    print("Notification shown");
  }

  tz.TZDateTime _convertDateTime(DateTime taskDate, int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, taskDate.year, taskDate.month, taskDate.day, hour, minutes);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  // Cancel a specific notification
  Future<void> cancelNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}