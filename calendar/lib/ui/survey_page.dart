// ignore_for_file: prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:calendar/Models%20/user.dart';
import 'package:calendar/db/db_helper.dart';
import 'package:calendar/services/theme_service.dart';
import 'package:calendar/ui/home_page.dart';
import 'package:calendar/ui/profile._page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:calendar/Models%20/survey_model.dart';
import 'package:calendar/controllers/survey_controller.dart';
import 'package:calendar/ui/widgets/button.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> with SingleTickerProviderStateMixin {
  final TextEditingController _preferredWorkHoursController = TextEditingController();
  final TextEditingController _taskTypesController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _feelingsController = TextEditingController();
  final TextEditingController _wakeUpTimeController = TextEditingController();
  final SurveyController _surveyController = SurveyController();
  DateTime _wakeUpTime = DateTime.now();
  List<bool> _workHoursSelected = List.generate(4, (index) => index == 0);
  List<String> _workHoursOptions = ["Morning", "Afternoon", "Evening","Night"];
  List<bool> _activeDaysSelected = List.generate(7, (index) => false);
  List<String> _activeDaysOptions = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  double _sleepHours = 8.0;

   

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ignore: prefer_const_constructors
              Column(
                children:  [
                  const Text(
                    "Welcome to Smart Calendar App",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Please fill this form",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildPreferredWorkHours(),
              const SizedBox(height: 10),
              _buildActiveDays(),
              const SizedBox(height: 10),
              _buildTaskTypes(),
              const SizedBox(height: 10),
              _buildMood(),
              const SizedBox(height: 10),
              _buildFeelings(),
              const SizedBox(height: 10),
              _buildSleepHours(),
              const SizedBox(height: 10),
              _buildWakeUpTime(),
              const SizedBox(height: 20),
              
              const SizedBox(height: 10), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                      MyButton(
              label: "Skip",
              onTap: () {
              Get.to(HomePage());
              
             }),

               MyButton(label: "Submit Survey", onTap: _submitSurveyData),
                ],
              )
               
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferredWorkHours() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Preferred Work Hours", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ToggleButtons(
            isSelected: _workHoursSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _workHoursSelected.length; i++) {
                  _workHoursSelected[i] = i == index;
                }
                _preferredWorkHoursController.text = _workHoursOptions[index];
              });
            },
            children: _workHoursOptions
                .map((option) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(option),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Active Days", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Column(
          children: _activeDaysOptions
              .asMap()
              .entries
              .map((entry) => SizedBox(
                    width: double.infinity,
                    child: CheckboxListTile(
                      title: Text(entry.value),
                      value: _activeDaysSelected[entry.key],
                      onChanged: (bool? value) {
                        setState(() {
                          _activeDaysSelected[entry.key] = value ?? false;
                        });
                      },
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTaskTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Task Types", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton(isExpanded: true,
          items: ["Work", "Study", "Exercise", "Leisure"]
              .map((type) => DropdownMenuItem(
                    value: type,
                   // alignment: Alignment.center,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              _taskTypesController.text = newValue!;
            });
          },
          value: _taskTypesController.text.isEmpty ? null : _taskTypesController.text,
          hint: const Text("Select task types"),
        ),
      ],
    );
  }

  Widget _buildMood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mood", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton(
          isExpanded: true,
          items: ["😀", "😐", "😢", "😡"]
              .map((emoji) => DropdownMenuItem(
                    value: emoji,
                    child: Text(emoji),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              _moodController.text = newValue!;
            });
          },
          value: _moodController.text.isEmpty ? null : _moodController.text,
          hint: const Text("Select your mood"),
        ),
      ],
    );
  }

  Widget _buildFeelings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Feelings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton(
          isExpanded: true,
          items: ["😊", "😌", "😔", "😫"]
              .map((emoji) => DropdownMenuItem(
                    value: emoji,
                    child: Text(emoji),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              _feelingsController.text = newValue!;
            });
          },
          value: _feelingsController.text.isEmpty ? null : _feelingsController.text,
          hint: const Text("Select your feelings"),
        ),
      ],
    );
  }

  Widget _buildSleepHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sleep Hours", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          value: _sleepHours,
          min: 1,
          max: 16,
          divisions: 15,
          label: _sleepHours.round().toString(),
          onChanged: (double value) {
            setState(() {
              _sleepHours = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildWakeUpTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Wake Up Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _wakeUpTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: DateFormat("hh:mm a").format(_wakeUpTime),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.access_time_rounded),
              onPressed: () {
                _getWakeUpTimeFromUser();
              },
            ),
          ],
        ),
      ],
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
    if (_preferredWorkHoursController.text.isNotEmpty &&
        _activeDaysSelected.contains(true) &&
        _taskTypesController.text.isNotEmpty &&
        _moodController.text.isNotEmpty &&
        _feelingsController.text.isNotEmpty &&
        _sleepHours > 0) {
              // Fetch the logged-in user
          User? loggedInUser = await DBhelper.getLoggedInUser();

    // Ensure we have a logged-in user
      String userId = loggedInUser!.userId!;
      Survey newSurvey = Survey(
        userId: userId, 
        preferredWorkHours: _preferredWorkHoursController.text,
        activeDays: _activeDaysOptions
            .asMap()
            .entries
            .where((entry) => _activeDaysSelected[entry.key])
            .map((entry) => entry.value)
            .toList(),
        taskTypes: _taskTypesController.text.split(',').map((e) => e.trim()).toList(),
        mood: _moodController.text,
        feelings: _feelingsController.text,
        sleepHours: _sleepHours,
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
      //elevation: 10,
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
}
