import 'package:uts_unsia/data/entity/data_entity.dart';

abstract class HabitDetailDatabase {
  Future<DataListEntity> allHabitDetail();
  Future<DataEntity> insertHabitDetail(final DataEntity entity);
  Future<void> updateHabitDetail(final DataEntity entity);
  Future<void> deleteHabitDetail(final int? id);
}