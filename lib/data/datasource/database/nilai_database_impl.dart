import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_unsia/data/datasource/database/nilai_database.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';

import 'mahasiswa_database_impl.dart' as mhs;

const tableName = 'nilai_table';
const columnId = 'id';
const columnMhsId = 'mhsId';
const columnNilaiAbsen = 'nilaiAbsen';
const columnNilaiTugas = 'nilaiTugas';
const columnNilaiUTS = 'nilaiUTS';
const columnNilaiUAS = 'nilaiUAS';

class NilaiDatabaseImpl implements NilaiDatabase {
  static const _databaseName = 'database';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  @override
  Future<DataListEntity> allNilai() async {
    final db = await database;
    return db.rawQuery(
      'select $tableName.*, ${mhs.tableName}.${mhs.columnNama}, '
      '${mhs.tableName}.${mhs.columnNim}, '
      '${mhs.tableName}.${mhs.columnProdi} '
      'from $tableName '
      'join ${mhs.tableName} on '
      '${mhs.tableName}.${mhs.columnId} = $tableName.$columnMhsId'
      '',
    );
  }

  @override
  Future<void> deleteNilai(int? id) async {
    if (id == null) return;
    final db = await database;
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<DataEntity> insertNilai(DataEntity entity) async {
    final db = await database;
    late final DataEntity nilaiEntity;
    await db.transaction((txn) async {
      final id = await txn.insert(
        tableName,
        entity,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('id $id, $entity');
      final results = await txn.rawQuery(
        'select $tableName.*, ${mhs.tableName}.${mhs.columnNama}, '
        '${mhs.tableName}.${mhs.columnNim}, '
        '${mhs.tableName}.${mhs.columnProdi} '
        'from $tableName '
        'join ${mhs.tableName} on '
        '${mhs.tableName}.${mhs.columnId} = $tableName.$columnMhsId '
        'where $tableName.$columnMhsId = ?',
        [id],
      );
      nilaiEntity = results.first;
    });
    return nilaiEntity;
  }

  @override
  Future<void> updateNilai(DataEntity entity) async {
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
          $columnMhsId INTEGER,
          $columnNilaiAbsen INTEGER NOT NULL,
          $columnNilaiTugas INTEGER NOT NULL,
          $columnNilaiUTS INTEGER NOT NULL,
          $columnNilaiUAS INTEGER NOT NULL
        )
        ''');

    return db;
  }
}
