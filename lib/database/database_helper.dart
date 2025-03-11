import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sections.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        time TEXT,
        completed INTEGER,
        color TEXT
      )
    ''');
  }

  Future<int> addSection(Map<String, dynamic> section) async {
    final db = await instance.database;
    return await db.insert('sections', section);
  }

  Future<List<Map<String, dynamic>>> getSections() async {
    final db = await instance.database;
    return await db.query('sections');
  }

  Future<int> updateSection(int id, int completed) async {
    final db = await instance.database;
    return await db.update(
      'sections',
      {'completed': completed},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
