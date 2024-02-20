import 'package:uts_unsia/domain/model/habit_detail.dart';
import 'package:uts_unsia/domain/model/habit_detail_list.dart';

abstract class HabitDetailRepo {
  Future<HabitDetailList> getHabitDetailList();
  Future<HabitDetail> createHabitDetail(HabitDetail nilai);
  Future<void> updateHabitDetail(HabitDetail nilai);
  Future<void> deleteHabitDetail(final HabitDetail nilai);
}