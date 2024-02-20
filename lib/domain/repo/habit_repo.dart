import 'package:uts_unsia/domain/model/habit.dart';
import 'package:uts_unsia/domain/model/habit_list.dart';

abstract class HabitRepo {
  Future<HabitList> getHabitList();
  Future<Habit> createHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(final Habit habit);
}