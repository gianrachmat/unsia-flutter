import 'package:uts_unsia/data/entity/data_entity.dart';
import 'package:uts_unsia/domain/model/habit_detail.dart';

class HabitDetailList {
  late List<HabitDetail> data;

  HabitDetailList({required this.data});

  HabitDetailList.fromMap(DataListEntity map) {
    data = map.map((e) => HabitDetail.fromMap(e)).toList();
  }

  DataListEntity toMap() {
    List<DataEntity> list = [];
    for (var element in data) {
      list.add(element.toMap());
    }
    return list;
  }
}