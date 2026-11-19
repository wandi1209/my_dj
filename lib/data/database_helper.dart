import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'mydj.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE jurnal ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'kelas TEXT, '
      'mapel TEXT, '
      'jam INTEGER, '
      'tujuanPembelajaran TEXT, '
      'materiTopikPembelajaran TEXT, '
      'kegiatanPembelajaran TEXT, '
      'dimensiProfilPelajarPancasila TEXT, '
      'createdAt TEXT)',
    );
  }
}
