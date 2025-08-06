import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tax_collect.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE taxpayers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT,
        phone TEXT,
        email TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE taxes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        dueDate TEXT,
        description TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        taxpayerId TEXT NOT NULL,
        taxId TEXT NOT NULL,
        amount REAL NOT NULL,
        method TEXT,
        date TEXT,
        receiptNumber TEXT,
        FOREIGN KEY (taxpayerId) REFERENCES taxpayers (id),
        FOREIGN KEY (taxId) REFERENCES taxes (id)
      )
    ''');
  }

  Future<void> initDB() async {
    await database;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}