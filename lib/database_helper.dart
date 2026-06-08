import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "FeedbackDB.db";
  static const _databaseVersion = 3;
  static const table = 'feedback';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        issueTitle TEXT NOT NULL,
        issueDescription TEXT NOT NULL,
        category TEXT NOT NULL,
        severity TEXT NOT NULL,
        attachments TEXT NOT NULL,
        profilePicturePath TEXT NOT NULL DEFAULT ''
      )
      ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      try {
        await db.execute(
          'ALTER TABLE $table ADD COLUMN profilePicturePath TEXT NOT NULL DEFAULT ""',
        );
      } catch (_) {} // Safely ignore if the column already exists
    }
  }

  Future<int> insertFeedback(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<int> deleteFeedback(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
