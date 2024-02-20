import 'package:flutter/material.dart';
import 'package:uts_unsia/data/datasource/database/habit_detail_database_impl.dart';
import 'package:uts_unsia/data/entity/data_entity.dart';
import 'package:uts_unsia/data/repository/habit_detail_repo_impl.dart';
import 'package:uts_unsia/domain/model/habit_detail.dart';
import 'package:uts_unsia/domain/model/habit_detail_list.dart';
import 'package:uts_unsia/domain/repo/habit_detail_repo.dart';
import 'package:uts_unsia/presentation/view/input_model_view.dart';
import 'package:uts_unsia/presentation/view/habit_list_page.dart';
import 'package:uts_unsia/presentation/view/add_habit_detail_page.dart';

class HabitDetailListPage extends StatefulWidget {
  const HabitDetailListPage({super.key, required this.title});

  final String title;

  @override
  State<HabitDetailListPage> createState() => _HabitDetailListPageState();
}

class _HabitDetailListPageState extends State<HabitDetailListPage> {
  final HabitDetailRepo _habitDetailRepo = HabitDetailRepoImpl(HabitDetailDatabaseImpl());
  HabitDetailList _habitDetailList = HabitDetailList(data: []);

  @override
  void initState() {
    super.initState();
    _getHabitDetail();
  }

  Future<void> _getHabitDetail() async {
    HabitDetailList hdList = await _habitDetailRepo.getHabitDetailList();
    setState(() {
      _habitDetailList = hdList;
    });
  }

  Widget _buildItem() {
    return _habitDetailList.data.isEmpty
        ? const Center(child: Text('Belum ada data'))
        : ListView.builder(
            itemCount: _habitDetailList.data.length,
            itemBuilder: (context, i) {
              debugPrint('habit detail ${_habitDetailList.data[i].toMap()}');
              DataEntity hd = _habitDetailList.data[i].toMap();
              List<Widget> children = [];
              hd.forEach((key, value) {
                Widget child = Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Text(key.camelToSentence()),
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
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddHabitDetailPage(
                        title: 'Update Habit',
                        isUpdate: true,
                        habitDetail: HabitDetail.fromMap(hd),
                      ),
                    ),
                  );
                  _getHabitDetail();
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
              builder: (_) => const HabitListPage(
                title: 'Choose Habit',
                isSelect: true,
              ),
            ),
          );
          _getHabitDetail();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
