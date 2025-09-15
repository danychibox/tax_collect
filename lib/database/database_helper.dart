// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/tax_data.dart';

// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   factory DatabaseService() => _instance;
//   DatabaseService._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'tax_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE tax_data(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         qrCodeId TEXT NOT NULL,
//         taxType TEXT NOT NULL,
//         payerName TEXT NOT NULL,
//         shopDesignation TEXT NOT NULL,
//         amount REAL NOT NULL,
//         paymentDate TEXT NOT NULL
//       )
//     ''');
//   }

//   Future<int> insertTaxData(TaxData taxData) async {
//     final db = await database;
//     return await db.insert('tax_data', taxData.toMap());
//   }

//   Future<List<TaxData>> getAllTaxData() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('tax_data');
//     return List.generate(maps.length, (i) {
//       return TaxData.fromMap(maps[i]);
//     });
//   }

//   Future<TaxData?> getTaxDataByQrCode(String qrCodeId) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'tax_data',
//       where: 'qrCodeId = ?',
//       whereArgs: [qrCodeId],
//     );
//     if (maps.isNotEmpty) {
//       return TaxData.fromMap(maps.first);
//     }
//     return null;
//   }
// }