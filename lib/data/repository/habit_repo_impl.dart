import 'package:uts_unsia/data/datasource/database/habit_database.dart';
import 'package:uts_unsia/domain/model/habit.dart';
import 'package:uts_unsia/domain/model/habit_list.dart';
import 'package:uts_unsia/domain/repo/habit_repo.dart';

class HabitRepoImpl implements HabitRepo {
  final HabitDatabase database;

  const HabitRepoImpl(this.database);

  @override
  Future<Habit> createHabit(Habit habit) async {
    final habitEntity = await database.insertHabit(habit.toMap());
    return Habit.fromMap(habitEntity);
  }

  @override
  Future<void> deleteHabit(Habit habit) async {
    await database.deleteHabit(habit.id);
  }

  @override
  Future<HabitList> getHabitList() async {
    final habitListEntity = await database.allHabit();
    return HabitList.fromMap(habitListEntity);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await database.updateHabit(habit.toMap());
  }

}