import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/absensi_model.dart';

class AbsensiDbHelper {
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDb();
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'absensi.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE absensi(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hari TEXT,
            tanggal TEXT,
            jamMasuk TEXT,
            latitude TEXT,
            longitude TEXT
            jamPulang TEXT,
          )
        ''');
      },
    );
  }

  Future<int> insertAbsensi(AbsensiModel model) async {
    final db = await database;
    return await db.insert('absensi', model.toMap());
  }

  Future<List<AbsensiModel>> getAllAbsensi() async {
    final db = await database;
    final maps = await db.query('absensi', orderBy: 'id DESC');
    return maps.map((e) => AbsensiModel.fromMap(e)).toList();
  }

  Future<void> updateJamPulang(String tanggal, String jamPulang) async {
    final db = await database;
    await db.update(
      'absensi',
      {'jamPulang': jamPulang},
      where: 'tanggal = ?',
      whereArgs: [tanggal],
    );
  }
}
