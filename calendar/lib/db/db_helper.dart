// ignore_for_file: prefer_const_declarations

import 'package:calendar/Models%20/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models /task.dart';

class DBhelper {
  static final int _version = 1;
  static final String _tableName = "tasks";
  static final String _userTableName = "user";
  static Database? _db;

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath();
      _path = join(_path, 'tasks.db');
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) async {
          print("Creating new database");
          await db.execute(
            "CREATE TABLE $_tableName ("
            "id TEXT PRIMARY KEY," // Changed to TEXT
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
            ");",
          );
           await db.execute(
            "CREATE TABLE $_userTableName ("
            "id TEXT PRIMARY KEY,"
            "name TEXT,"
            "email TEXT,"
            "token TEXT"
            ");",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    print("Insert function called");

    if (_db == null) {
      print("Database is not initialized");
      return Future.error("Database is not initialized");
    }

    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("Query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<int> update(Task task) async {
    print("Update function called");
    if (_db == null) {
      print("Database is not initialized");
      return Future.error("Database is not initialized");
    }
    return await _db!.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

// User-related methods
  static Future<int> insertUser(User user) async {
    if (_db == null) {
      return Future.error("Database is not initialized");
    }
    return await _db!.insert(_userTableName, user.toJson());
  }

  static Future<List<User>> queryUsers() async {
    if (_db == null) {
      return Future.error("Database is not initialized");
    }
    final List<Map<String, dynamic>> maps = await _db!.query(_userTableName);
    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  static Future<int> deleteUser(String id) async {
    if (_db == null) {
      return Future.error("Database is not initialized");
    }
    return await _db!.delete(_userTableName, where: 'id=?', whereArgs: [id]);
  }
}
  

