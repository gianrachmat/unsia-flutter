import 'package:uts_unsia/data/entity/data_entity.dart';
import 'package:uts_unsia/domain/model/habit.dart';

class HabitList {
  late List<Habit> data;

  HabitList({required this.data});

  HabitList.fromMap(DataListEntity map) {
    data = map.map((e) => Habit.fromMap(e)).toList();
  }

  DataListEntity toMap() {
    List<DataEntity> list = [];
    for (var element in data) {
      list.add(element.toMap());
    }
    return list;
  }
}
