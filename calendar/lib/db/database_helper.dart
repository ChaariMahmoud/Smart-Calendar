import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
      id TEXT PRIMARY KEY AUTOINCREMENT,
      note TEXT NOT NULL,
      type TEXT NOT NULL,
      date TEXT NOT NULL ,
      beginTime TEXT NOT NULL,
      endTime TEXT NOT NULL,
      priority INTEGER NOT NULL,
      difficulty INTEGER NOT NULL,
      userId TEXT NOT NULL,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      color INTEGER NOT NULL,
      successPercentage REAL NOT NULL,
    )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
