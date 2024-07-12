import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todolist.db');
    print('Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
        CREATE TABLE todos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          createdDateTime TEXT,
          dueDateTime TEXT,
          priority INTEGER DEFAULT 10,
          completed INTEGER DEFAULT 0
        )
        ''',
        );
      },
    );
  }

  Future<int> addTodo(String title, String? description, int priority, String dueDateTime,String dateTime) async {
    final db = await database;
    return await db.insert(
      'todos',
      {
        'title': title,
        'description': description,
        'priority': priority,
        'dueDateTime': dueDateTime,
        'createdDateTime': dateTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTodo(int id, String title, String? description, int priority, String dueDateTime, String dateTime) async {
    final db = await database;
    return await db.update(
      'todos',
      {
        'title': title,
        'description': description,
        'priority': priority,
        'dueDateTime': dueDateTime,
        'createdDateTime': dateTime,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCompletionStatus(int id, bool completed) async {
    final db = await database;
    await db.update(
      'todos',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final db = await database;
    return await db.query(
      'todos',
      orderBy: 'priority ASC',
    );
  }
}
