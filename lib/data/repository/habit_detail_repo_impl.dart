import 'package:flutter/foundation.dart';
import 'package:uts_unsia/data/datasource/database/habit_detail_database.dart';
import 'package:uts_unsia/domain/model/habit_detail.dart';
import 'package:uts_unsia/domain/model/habit_detail_list.dart';
import 'package:uts_unsia/domain/repo/habit_detail_repo.dart';

class HabitDetailRepoImpl implements HabitDetailRepo {
  final HabitDetailDatabase database;

  const HabitDetailRepoImpl(this.database);

  @override
  Future<HabitDetail> createHabitDetail(HabitDetail hd) async {
    debugPrint('nilai mhs ${hd.habit.toMap()}');
    final nilaiEntity = await database.insertHabitDetail(hd.toMap(insert: true));
    return HabitDetail.fromMap(nilaiEntity);
  }

  @override
  Future<void> deleteHabitDetail(HabitDetail hd) async {
    await database.deleteHabitDetail(hd.id);
  }

  @override
  Future<HabitDetailList> getHabitDetailList() async {
    final nilaiListEntity = await database.allHabitDetail();
    return HabitDetailList.fromMap(nilaiListEntity);
  }

  @override
  Future<void> updateHabitDetail(HabitDetail hd) async {
    await database.updateHabitDetail(hd.toMap(insert: true));
  }

}