import 'package:uts_unsia/data/entity/data_entity.dart';

abstract class HabitDatabase {
  Future<DataListEntity> allHabit();
  Future<DataEntity> insertHabit(final DataEntity entity);
  Future<void> updateHabit(final DataEntity entity);
  Future<void> deleteHabit(final int? id);
}