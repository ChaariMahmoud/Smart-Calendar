// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_declarations, prefer_interpolation_to_compose_strings, avoid_print

import 'package:calendar/Models%20/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBhelper {
  static final int _version = 1;
  static final String _tableName = "tasks";
  static Database? _db;
  Task? task ;

  Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath();
      _path = join(_path, 'tasks.db'); 
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("creating new database");
          return db.execute(
            "CREATE TABLE $_tableName ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title TEXT NOT NULL,"
            "note TEXT NOT NULL,"
            "type TEXT NOT NULL,"
            "date TEXT NOT NULL,"
            "beginTime TEXT NOT NULL,"
            "endTime TEXT NOT NULL,"
            "priority INTEGER NOT NULL,"
            "difficulty INTEGER NOT NULL,"
            "userId TEXT NOT NULL,"
            "createdAt TEXT NOT NULL,"
            "updatedAt TEXT NOT NULL,"
            "color INTEGER NOT NULL,"
            "successPercentage REAL NOT NULL"
            ");" 
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db!.insert(_tableName, task!.toJson());    ///////////////////////////////
  }

  static Future<List<Map<String,dynamic>>> querry() async{
     print("querry function called");
     return await _db!.query(_tableName);
  }
}
