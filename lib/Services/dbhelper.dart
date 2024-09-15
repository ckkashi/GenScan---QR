import 'package:genscan_qr/Models/qrdata.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/qrdata.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'qrdata.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qrs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        data TEXT,
        type TEXT,
        nature TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<List<QrData>> checkQrUsingData(String data) async {
    final db = await database;
    var result = await db.query(
      'qrs',
      where: 'data = ?',
      whereArgs: [data],
    );
    List<QrData> qrDataList = result.isNotEmpty
        ? result.map((item) => QrData.fromMap(item)).toList()
        : [];
    return qrDataList;
  }

  Future<int> insertQrData(QrData qrData) async {
    List<QrData> lst = await checkQrUsingData(qrData.data);
    if (lst.length > 0) {
      return 0;
    } else {
      Database db = await database;
      return await db.insert('qrs', qrData.toMap());
    }
  }

  Future<List<QrData>> getAllQrData() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('qrs');
    return List.generate(maps.length, (i) {
      return QrData.fromMap(maps[i]);
    });
  }
}
