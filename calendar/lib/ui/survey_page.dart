import 'package:calendar/services/theme_service.dart';
import 'package:calendar/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:calendar/Models%20/survey_model.dart';
import 'package:calendar/controllers/survey_controller.dart';
import 'package:calendar/ui/widgets/button.dart';
import 'package:calendar/ui/widgets/input_field.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _preferredWorkHoursController = TextEditingController();
  final TextEditingController _activeDaysController = TextEditingController();
  final TextEditingController _taskTypesController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _feelingsController = TextEditingController();
  final TextEditingController _sleepHoursController = TextEditingController();
  final TextEditingController _wakeUpTimeController = TextEditingController();
  final SurveyController _surveyController = SurveyController();
  DateTime _wakeUpTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              MyInputField(
                title: "Preferred Work Hours",
                hint: "Enter preferred work hours",
                controller: _preferredWorkHoursController,
              ),
              MyInputField(
                title: "Active Days",
                hint: "Enter active days",
                controller: _activeDaysController,
              ),
              MyInputField(
                title: "Task Types",
                hint: "Enter task types",
                controller: _taskTypesController,
              ),
              MyInputField(
                title: "Mood",
                hint: "Enter your mood",
                controller: _moodController,
              ),
              MyInputField(
                title: "Feelings",
                hint: "Enter your feelings",
                controller: _feelingsController,
              ),
              MyInputField(
                title: "Sleep Hours",
                hint: "Enter sleep hours",
                controller: _sleepHoursController,
              ),
              MyInputField(
                title: "Wake Up Time",
                hint: DateFormat("hh:mm a").format(_wakeUpTime),
                widget: IconButton(
                  icon: const Icon(Icons.access_time_rounded),
                  onPressed: () {
                    _getWakeUpTimeFromUser();
                  },
                ),
              ),
              const SizedBox(height: 20),
              MyButton(label: "Submit Survey", onTap: _submitSurveyData),
            ],
          ),
        ),
      ),
    );
  }

  _getWakeUpTimeFromUser() async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_wakeUpTime),
    );
    if (pickedTime != null) {
      setState(() {
        _wakeUpTime = DateTime(
          _wakeUpTime.year,
          _wakeUpTime.month,
          _wakeUpTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _wakeUpTimeController.text = DateFormat("hh:mm a").format(_wakeUpTime);
      });
    }
  }

  _submitSurveyData() async {
    if (
        _preferredWorkHoursController.text.isNotEmpty &&
        _activeDaysController.text.isNotEmpty &&
        _taskTypesController.text.isNotEmpty &&
        _moodController.text.isNotEmpty &&
        _feelingsController.text.isNotEmpty &&
        _sleepHoursController.text.isNotEmpty 
        ) {
      Survey newSurvey = Survey(
        userId: "test",
        preferredWorkHours: _preferredWorkHoursController.text,
        activeDays: _activeDaysController.text.split(',').map((e) => e.trim()).toList(),
        taskTypes: _taskTypesController.text.split(',').map((e) => e.trim()).toList(),
        mood: _moodController.text,
        feelings: _feelingsController.text,
        sleepHours: double.parse(_sleepHoursController.text),
        wakeUpTime: _wakeUpTimeController.text,
      );

      bool success = await _surveyController.submitSurvey(newSurvey);
      if (success) {
        Get.snackbar("Success", "Survey submitted successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
        await Get.to(() => const HomePage());
      } else {
        Get.snackbar("Error", "Failed to submit survey",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.pink,
        ));
      }
    } else {
      Get.snackbar("Required", "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
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
}
