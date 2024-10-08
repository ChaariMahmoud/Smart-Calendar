import 'package:calendar/db/db_helper.dart';
import 'package:calendar/services/theme_service.dart';
import 'package:calendar/ui/start_page.dart';
//import 'package:calendar/ui/home_page.dart';
//import 'package:calendar/ui/survey_page.dart';
import 'package:calendar/ui/theme.dart';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBhelper.initDb();
  runApp(  const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Calendar - Orange Innovation Cup',
    
      
      theme: Themes.dark,
      
      darkTheme: Themes.light,
      themeMode: ThemeService().theme,
      

   

      home:   StartPage(),
    );
  }
}



