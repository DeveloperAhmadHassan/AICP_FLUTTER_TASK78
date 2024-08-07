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
    String path = join(await getDatabasesPath(), 'wishlist.db');
    print('Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
        CREATE TABLE wishlist(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          pid INTEGER,
          imageUrl TEXT,
          dateTime Text
        )
        ''',
        );
      },
    );
  }

  Future<int> addProduct(String title, int pid, String dateTime, String imageUrl) async {
    final db = await database;
    return await db.insert(
      'wishlist',
      {
        'title': title,
        'pid': pid,
        'imageUrl': imageUrl,
        'dateTime': dateTime
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteProduct(int pid) async {
    final db = await database;
    return await db.delete(
      'wishlist',
      where: 'pid = ?',
      whereArgs: [pid],
    );
  }

  Future<bool> isProductExists(int pid) async {
    final db = await database;
    var result = await db.query(
      'wishlist',
      where: 'pid = ?',
      whereArgs: [pid],
    );
    return result.isNotEmpty;
  }


  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final db = await database;
    return await db.query('wishlist');
  }
}
