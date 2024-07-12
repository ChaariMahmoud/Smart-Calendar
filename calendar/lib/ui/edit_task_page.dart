import 'package:calendar/Models%20/task.dart';
import 'package:calendar/controllers/task_controller.dart';
import 'package:calendar/ui/theme.dart';
import 'package:calendar/ui/widgets/button.dart';
import 'package:calendar/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({required this.task, super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late DateTime _selectedDate;
  late String _endTime;
  late String _startTime;
  late int _selectedDifficulty;
  late int _selectedColor;
  late int _selectedPriority;
  final List<bool> _isSelected = List.generate(5, (index) => false);
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late TextEditingController _typeController;
  final TaskController _taskController = Get.put(TaskController());

  List<int> difficultyList = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    //_taskController.getTasks();
    _selectedDate = DateFormat.yMd().parse(widget.task.date);
    _endTime = widget.task.endTime;
    _startTime = widget.task.beginTime;
    _selectedDifficulty = widget.task.difficulty;
    _selectedColor = widget.task.color;
    _selectedPriority = widget.task.priority;
    _isSelected[_selectedPriority - 1] = true;
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note);
    _typeController = TextEditingController(text: widget.task.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Task",
                style: headingStyle,
              ),
              MyInputField(
                title: "Title",
                hint: "Enter title here",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter note here",
                controller: _noteController,
              ),
              MyInputField(
                title: "Type",
                hint: "Enter type here",
                controller: _typeController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMMMMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _getDateFromUser();
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
              MyInputField(
                title: "Difficulty",
                hint: "Select the difficulty level for your task",
                widget: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  iconSize: 30,
                  elevation: 5,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items: difficultyList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDifficulty = int.parse(newValue!);
                    });
                  },
                  value: _selectedDifficulty.toString(),
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      MyButton(label: "Save Changes", onTap: () async {
                        await _validateData();
                        _taskController.getTasks();
                      } ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 10,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back_ios,
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
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
      initialEntryMode: TimePickerEntryMode.input,
    );
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 10),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: index == 0 ? primaryClr : index == 1 ? pinkClr : yellowClr,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 15,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty && _typeController.text.isNotEmpty) {
      _updateTaskInDb();
      Get.back();
    } else {
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

  _updateTaskInDb() async {
    Task updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      note: _noteController.text,
      type: _typeController.text,
      date: DateFormat.yMd().format(_selectedDate),
      beginTime: _startTime,
      endTime: _endTime,
      successPercentage: widget.task.successPercentage,
      difficulty: _selectedDifficulty,
      priority: _selectedPriority,
      color: _selectedColor,
    );

    print("UpdateTaskToDb: Task details before update: ${updatedTask.toJson()}");

    int value = await _taskController.updateTask(updatedTask);
    print("UpdateTaskToDb: Updated task id is $value");
  }
}