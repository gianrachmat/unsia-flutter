import 'package:uts_unsia/data/datasource/database/habit_database_impl.dart'
    as hbt;
import 'package:uts_unsia/data/datasource/database/habit_detail_database_impl.dart';
import 'package:uts_unsia/data/entity/data_entity.dart';

import 'habit.dart';

class HabitDetail {
  late int? id;
  late Habit habit;
  late String habitDate;

  HabitDetail({
    required this.id,
    required this.habit,
    required this.habitDate,
  });

  HabitDetail.fromMap(DataEntity map) {
    id = map[columnId];
    habit = Habit.fromMap(map);
    habitDate = map[columnHabitDate];
  }

  Map<String, dynamic> toMap({bool insert = false}) {
    final Map<String, dynamic> map = {};
    map[columnId] = id;
    map[columnHabitId] = habit.id;
    if (!insert) {
      map[hbt.columnHbName] = habit.habitName;
      map[hbt.columnGoal] = habit.habitGoal;
    }
    map[columnHabitDate] = habitDate;

    return map;
  }
}
