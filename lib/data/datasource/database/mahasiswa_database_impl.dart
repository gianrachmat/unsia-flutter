import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_unsia/data/datasource/database/mahasiswa_database.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';

const tableName = 'mahasiswa_table';
const columnId = 'id';
const columnNama = 'nama';
const columnNim = 'nim';
const columnProdi = 'prodi';

class MahasiswaDatabaseImpl implements MahasiswaDatabase {
  static const _databaseName = 'database';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  @override
  Future<DataListEntity> allMahasiswa() async {
    final db = await database;
    return db.query(tableName);
  }

  @override
  Future<void> deleteMahasiswa(int? id) async {
    if (id == null) return;
    final db = await database;
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<DataEntity> insertMahasiswa(DataEntity entity) async {
    final db = await database;
    late final DataEntity mhsEntity;
    await db.transaction((txn) async {
      final id = await txn.insert(
        tableName,
        entity,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final results = await txn.query(
        tableName,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      mhsEntity = results.first;
    });
    return mhsEntity;
  }

  @override
  Future<void> updateMahasiswa(DataEntity entity) async {
    final db = await database;
    final int id = entity['id'];
    await db.update(
      tableName,
      entity,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<Database> _initDatabase() async {
    var db = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
    );

    await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableName(
          $columnId INTEGER PRIMARY KEY NOT NULL,
          $columnNama TEXT NOT NULL,
          $columnNim TEXT NOT NULL,
          $columnProdi TEXT NOT NULL
        )
        ''');

    return db;
  }
}
