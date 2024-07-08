import 'package:calendar/ui/theme.dart';
import 'package:calendar/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
   DateTime _selectedDate = DateTime.now() ;
   String _endTime = "11:59 PM";
   String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: _appBar(context),
      body: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.only(left: 15 , right: 15,bottom: 20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task" ,
              style: headingStyle,),
              const MyInputField(title: "Title",hint: "Enter title here",),
              const MyInputField(title: "Note",hint: "enter note here",),
              const MyInputField(title: "Type",hint: "Enter type here",),
               MyInputField(title: "Date",
               hint: DateFormat.yMMMMd().format(_selectedDate),
               widget: IconButton(
                     icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      _getDateFromUser();
                    },
              ),),
               Row(
                children: [
                 Expanded(child: MyInputField(
                          title: "Start Time",
                          hint: _startTime,
                          widget: IconButton(
                          icon: const Icon(Icons.access_time_rounded),
                          onPressed: () {
                          },
                            ),
                          ),) ,
                          const SizedBox(width: 10,),
                      Expanded(child: 
                  MyInputField(
                          title: "End Time",
                          hint: _endTime,
                          widget: IconButton(
                          icon: const Icon(Icons.access_time_rounded),
                          onPressed: () {},
          ),
        ),
                  
                  ),


                 
                ],
              ),
              const MyInputField(title: "Success Percentage",hint: "Enter Success Percentage here",),
              const MyInputField(title: "Difficulty",hint: "Enter difficulty here",),
              
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
        )
      ],
    );
  }

  _getDateFromUser() async {

    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100));

      if (pickerDate!=null){
        setState(() {
          _selectedDate =pickerDate ;
        });
      }
  }


  
}