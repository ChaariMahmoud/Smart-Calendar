import 'package:calendar/services/notification_services.dart';
import 'package:calendar/services/theme_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  @override
  void initState(){
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.requestIOSPermissions();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
        body:const Column(children: [
          Text("theme data",style: TextStyle(fontSize: 30))
        ],)
      ,
    );
  }
  AppBar _appBar(){
   return AppBar(
    elevation: 0,
    leading: GestureDetector(
      onTap: (){
       ThemeService().switchTheme();
      },
      child:  const Icon(Icons.nightlight_round ,size: 20),
    ),
    actions: const [
      Icon(Icons.person ,size: 20),
      SizedBox(width: 20)
    ],
  );
}
}

