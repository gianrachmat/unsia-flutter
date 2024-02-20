import 'package:flutter/material.dart';
import 'package:uts_unsia/data/datasource/database/habit_database_impl.dart';
import 'package:uts_unsia/data/entity/data_entity.dart';
import 'package:uts_unsia/data/repository/habit_repo_impl.dart';
import 'package:uts_unsia/domain/model/habit.dart';
import 'package:uts_unsia/domain/model/habit_list.dart';
import 'package:uts_unsia/domain/repo/habit_repo.dart';
import 'package:uts_unsia/presentation/view/input_model_view.dart';
import 'package:uts_unsia/presentation/view/add_habit_page.dart';
import 'package:uts_unsia/presentation/view/add_habit_detail_page.dart';

class HabitListPage extends StatefulWidget {
  const HabitListPage({
    super.key,
    required this.title,
    this.isSelect = false,
  });

  final String title;
  final bool isSelect;

  @override
  State<HabitListPage> createState() => _HabitListPage();
}

class _HabitListPage extends State<HabitListPage> {
  final HabitRepo _habitRepo = HabitRepoImpl(HabitDatabaseImpl());
  HabitList _habitList = HabitList(data: []);

  @override
  void initState() {
    super.initState();
    _getHabit();
  }

  Future<void> _getHabit() async {
    HabitList mhsList = await _habitRepo.getHabitList();
    setState(() {
      _habitList = mhsList;
    });
  }

  Widget _buildItem() {
    return _habitList.data.isEmpty
        ? const Center(child: Text('Belum ada data'))
        : ListView.builder(
            itemCount: _habitList.data.length,
            itemBuilder: (context, i) {
              DataEntity mhs = _habitList.data[i].toMap();
              List<Widget> children = [];
              mhs.forEach((key, value) {
                Widget child = Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Text(key.capitalize()),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 4,
                      child: Text("$value"),
                    ),
                  ],
                );
                children.add(child);
              });
              return GestureDetector(
                onTap: () async {
                  Widget builder = widget.isSelect
                      ? AddHabitDetailPage(
                          title: 'Add Habit Detail',
                          habit: Habit.fromMap(mhs),
                        )
                      : AddHabitPage(
                          title: 'Add Habit',
                          mhs: Habit.fromMap(mhs),
                          isUpdate: true,
                        );
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => builder,
                    ),
                  );
                  if (widget.isSelect) {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  } else {
                    _getHabit();
                  }
                },
                child: Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: children),
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: _buildItem(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddHabitPage(
                title: 'Add Habit',
              ),
            ),
          );
          _getHabit();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
