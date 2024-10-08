import 'package:calendar/controllers/task_controller.dart';
import 'package:calendar/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models /task.dart';


class TaskTile extends StatefulWidget {
  final Task? task;
  TaskTile(this.task);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
   double _successPercentage = 0.0;
   
  final TaskController _taskController = TaskController();
 
  @override
  void initState() {
    super.initState();
    _initializeSuccessPercentage();

  }
  
  void _initializeSuccessPercentage() async {
    if (widget.task != null) {
      Task? localTask = await _taskController.getLocalTaskById(widget.task!.id);
      if (localTask != null) {
        setState(() {
          _successPercentage = localTask.successPercentage;
        });
      } else {
        setState(() {
          _successPercentage = widget.task!.successPercentage;
        });
      }
    }
  }
  
  void _updateSuccessPercentage(double value) {
    setState(() {
      _successPercentage = value;
    });

    Task updatedTask = widget.task!.copyWith(successPercentage: _successPercentage);
    _taskController.updateTask(updatedTask);
    _taskController.updateTaskInBackend(updatedTask);
    _taskController.synchronizeTasks();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark ;
     
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border:  Border.all(color :_getBGClr(widget.task?.color ?? 0)),
         // color: _getBGClr(widget.task?.color ?? 0),
          color: isDark? Colors.grey[900] : Colors.grey[200]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task?.title ?? "",
              style: GoogleFonts.lato(
                textStyle:  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark? Colors.white : Colors.black
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: isDark? Colors.white : Colors.black,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  "${widget.task!.beginTime} - ${widget.task!.endTime}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 13, color: isDark? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "note  :   ${widget.task?.note ?? ""}",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 15, color: isDark? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Type  :   ${widget.task?.type ?? ""}",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 15,
                  color: isDark? Colors.white : Colors.black,
                ),
              ),
            ),
            Slider(
              value: _successPercentage,
              min: 0,
              max: 100,
              divisions: 100,
              label: _successPercentage.round().toString(),
              onChanged: (double value) {
                _updateSuccessPercentage(value);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _successPercentage == 100 ? "COMPLETED" : "TODO",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Text(
                  "${_successPercentage.round()}%",
                  style: GoogleFonts.lato(
                    textStyle:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}