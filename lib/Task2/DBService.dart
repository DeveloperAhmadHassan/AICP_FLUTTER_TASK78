import 'package:aicp_internship/Task2/Quote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  static Database? _database;

  DBService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quotes.db');
    print('Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE quotes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quote TEXT,
            author TEXT,
            type TEXT
          )
        ''',
        );
      },
    );
  }

  Future<List<Quote>> getFavoriteQuotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('quotes');
    return List.generate(maps.length, (i) {
      return Quote(
        id: maps[i]['id'].toString(),
        quote: maps[i]['quote'],
        author: maps[i]['author'],
        type: maps[i]['type']
      );
    });
  }

  Future<int> insertQuote(String quote, String author, String type) async {
    try {
      Database db = await database;

      List<Map<String, dynamic>> existingQuotes = await db.query(
        'quotes',
        where: 'quote = ? AND author = ?',
        whereArgs: [quote, author],
      );

      if (existingQuotes.isEmpty) {
        await db.insert(
          'quotes',
          {
            'quote': quote,
            'author': author,
            'type': type,
          },
        );
        print('Quote inserted');
        return 1;
      } else {
        print('Quote already exists');
        return 0;
      }
    } catch (e) {
      print('Error inserting quote: $e');
      return -1;
    }
  }

  Future<void> deleteQuote(String quote, String author) async {
    try {
      Database db = await database;

      // Delete the quote
      int count = await db.delete(
        'quotes',
        where: 'quote = ? AND author = ?',
        whereArgs: [quote, author],
      );

      if (count > 0) {
        print('Quote deleted');
      } else {
        print('Quote not found');
      }
    } catch (e) {
      print('Error deleting quote: $e');
      // return -1;
    }
  }

  Future<void> clearDatabase() async {
    try {
      Database db = await database;
      await db.delete('quotes');
      print('Database cleared successfully');
    } catch (e) {
      print('Error clearing database: $e');
    }
  }

}
