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
    String path = join(await getDatabasesPath(), 'expressions.db');
    print('Database path: $path'); // Debug print statement
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
        CREATE TABLE expressions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          expression TEXT,
          result TEXT,
          result_type TEXT
        )
        ''',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchAllExpressions() async {
    Database db = await database;
    return await db.query('expressions');
  }

  Future<int> insertExpression(String expression, String result, String resultType) async {
    try {
      Database db = await database;
      return await db.insert(
        'expressions',
        {
          'expression': expression,
          'result': result,
          'result_type': resultType,
        },
      );
    } catch (e) {
      print('Error inserting expression: $e'); // Debug print statement
      return -1;
    }
  }

  Future<void> clearDatabase() async {
    try {
      Database db = await database;
      await db.delete('expressions');
      print('Database cleared successfully');
    } catch (e) {
      print('Error clearing database: $e');
    }
  }

}
