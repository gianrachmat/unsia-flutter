import 'package:flutter/foundation.dart';
import 'package:uts_unsia/data/datasource/database/habit_database_impl.dart';
import 'package:uts_unsia/data/datasource/database/habit_detail_database_impl.dart'
    as detail;
import 'package:uts_unsia/data/entity/data_entity.dart';

class Habit {
  late int? id;
  late String habitName;
  late String habitGoal;

  Habit({
    required id,
    required prodi,
    required nim,
  });

  Habit.fromMap(DataEntity map) {
    debugPrint('map mhs $map');
    id = map[detail.columnHabitId] ?? map[columnId];
    habitName = map[columnHbName];
    habitGoal = map[columnGoal];
  }

  DataEntity toMap() {
    DataEntity data = {};
    data[columnId] = id;
    data[columnHbName] = habitName;
    data[columnGoal] = habitGoal;

    return data;
  }
}
