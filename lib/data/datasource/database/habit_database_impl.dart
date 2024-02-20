import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_unsia/data/datasource/database/habit_database.dart';
import 'package:uts_unsia/data/entity/data_entity.dart';

const tableName = 'habit_table';
const columnId = 'id';
const columnHbName = 'habitName';
const columnGoal = 'habitGoal';

class HabitDatabaseImpl implements HabitDatabase {
  static const _databaseName = 'database';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  @override
  Future<DataListEntity> allHabit() async {
    final db = await database;
    return db.query(tableName);
  }

  @override
  Future<void> deleteHabit(int? id) async {
    if (id == null) return;
    final db = await database;
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<DataEntity> insertHabit(DataEntity entity) async {
    final db = await database;
    late final DataEntity dataEntity;
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
      dataEntity = results.first;
    });
    return dataEntity;
  }

  @override
  Future<void> updateHabit(DataEntity entity) async {
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
          $columnHbName TEXT NOT NULL,
          $columnGoal TEXT NOT NULL
        )
        ''');

    return db;
  }
}
