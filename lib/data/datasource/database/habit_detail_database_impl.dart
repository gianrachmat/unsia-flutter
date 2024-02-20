import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_unsia/data/datasource/database/habit_detail_database.dart';
import 'package:uts_unsia/data/entity/data_entity.dart';

import 'habit_database_impl.dart' as hbt;

const tableName = 'habit_detail_table';
const columnId = 'id';
const columnHabitId = 'habitId';
const columnHabitDate = 'habitDate';

class HabitDetailDatabaseImpl implements HabitDetailDatabase {
  static const _databaseName = 'database';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  @override
  Future<DataListEntity> allHabitDetail() async {
    final db = await database;
    return db.rawQuery(
      'select $tableName.*, '
      '${hbt.tableName}.${hbt.columnHbName}, '
      '${hbt.tableName}.${hbt.columnGoal} '
      'from $tableName '
      'join ${hbt.tableName} on '
      '${hbt.tableName}.${hbt.columnId} = $tableName.$columnHabitId'
      '',
    );
  }

  @override
  Future<void> deleteHabitDetail(int? id) async {
    if (id == null) return;
    final db = await database;
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<DataEntity> insertHabitDetail(DataEntity entity) async {
    final db = await database;
    late final DataEntity dataEntity;
    await db.transaction((txn) async {
      final id = await txn.insert(
        tableName,
        entity,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('id $id, $entity');
      final results = await txn.rawQuery(
        'select $tableName.*, '
        '${hbt.tableName}.${hbt.columnHbName}, '
        '${hbt.tableName}.${hbt.columnGoal} '
        'from $tableName '
        'join ${hbt.tableName} on '
        '${hbt.tableName}.${hbt.columnId} = $tableName.$columnHabitId '
        'where $tableName.$columnId = ?',
        [id],
      );
      dataEntity = results.first;
    });
    return dataEntity;
  }

  @override
  Future<void> updateHabitDetail(DataEntity entity) async {
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
          $columnHabitId INTEGER,
          $columnHabitDate TEXT NOT NULL
        )
        ''');

    return db;
  }
}
