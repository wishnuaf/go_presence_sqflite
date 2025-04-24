import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../models/absensi_model.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDb();
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT,
            email TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE absensi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hari TEXT,
            tanggal TEXT,
            jamMasuk TEXT,
            latitude TEXT,
            longitude TEXT,
            jamPulang TEXT
          )
        ''');
      },
    );
  }

  // ========================= USER =========================
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  Future<UserModel?> login(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  // ======================= ABSENSI =======================
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
