import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_unsia/data/datasource/database/nilai_database.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';

class NilaiDatabaseImpl implements NilaiDatabase {
  static const _databaseName = 'database';
  static const _tableName = 'nilai_table';
  static const _databaseVersion = 1;
  static const _columnId = 'id';
  static const _columnNama = 'nama';
  static const _columnNim = 'nim';
  static const _columnProdi = 'prodi';
  static const _columnNilaiAbsen = 'nilaiAbsen';
  static const _columnNilaiTugas = 'nilaiTugas';
  static const _columnNilaiUTS = 'nilaiUTS';
  static const _columnNilaiUAS = 'nilaiUAS';
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  @override
  Future<NilaiListEntity> allNilai() async {
    final db = await database;
    return db.query(_tableName);
  }

  @override
  Future<void> deleteNilai(int? id) async {
    if (id == null) return;
    final db = await database;
    await db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  @override
  Future<NilaiEntity> insertNilai(NilaiEntity entity) async {
    final db = await database;
    late final NilaiEntity nilaiEntity;
    await db.transaction((txn) async {
      final id = await txn.insert(
        _tableName,
        entity,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final results = await txn.query(
        _tableName,
        where: '$_columnId = ?',
        whereArgs: [id],
      );
      nilaiEntity = results.first;
    });
    return nilaiEntity;
  }

  @override
  Future<void> updateNilai(NilaiEntity entity) async {
    final db = await database;
    final int id = entity['id'];
    await db.update(
      _tableName,
      entity,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  Future<Database> _initDatabase() async {
    var db = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
    );

    await db.execute('''
        CREATE TABLE IF NOT EXISTS $_tableName(
          $_columnId INTEGER PRIMARY KEY NOT NULL,
          $_columnNama TEXT NOT NULL,
          $_columnNim TEXT NOT NULL,
          $_columnProdi TEXT NOT NULL,
          $_columnNilaiAbsen INTEGER NOT NULL,
          $_columnNilaiTugas INTEGER NOT NULL,
          $_columnNilaiUTS INTEGER NOT NULL,
          $_columnNilaiUAS INTEGER NOT NULL
        )
        ''');

    return db;
  }
}
