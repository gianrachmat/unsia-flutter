import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uts_unsia/data/datasource/database/habit_database_impl.dart';
import 'package:uts_unsia/data/entity/data_entity.dart';
import 'package:uts_unsia/data/repository/habit_repo_impl.dart';
import 'package:uts_unsia/domain/model/habit.dart';
import 'package:uts_unsia/domain/repo/habit_repo.dart';
import 'package:uts_unsia/presentation/view/input_model_view.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({
    super.key,
    required this.title,
    this.isUpdate = false,
    this.mhs,
    this.isSelect = false,
  });

  final String title;
  final bool isUpdate;
  final Habit? mhs;
  final bool isSelect;

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final HabitRepo _mhsRepo = HabitRepoImpl(HabitDatabaseImpl());
  bool _loading = false;
  late List<InputModel> _models;

  @override
  void initState() {
    super.initState();
    _models = _generateModel();
    debugPrint('is update? ${widget.isUpdate}');
  }

  void _pressButton(String button) {
    switch (button) {
      case 'Update':
      case 'Tambah':
        _pressTambah();
        break;
      case 'Hapus':
        _pressHapus();
        break;
      default:
        break;
    }
  }

  Future<void> _pressTambah() async {
    DataEntity entity = {};
    bool empty = false;
    if (widget.isUpdate) {
      entity.addAll(widget.mhs!.toMap());
    }
    for (var im in _models) {
      if (im.type == InputType.text || im.type == InputType.number) {
        if (im.controller!.text.isEmpty) {
          empty = true;
          return;
        } else {
          if (im.type == InputType.number) {
            entity[im.field] = int.tryParse(im.controller!.text);
          } else {
            entity[im.field] = im.controller!.text;
          }
        }
      }
    }
    if (!empty) {
      setState(() {
        _loading = true;
      });
      if (widget.isUpdate) {
        await _mhsRepo.updateHabit(Habit.fromMap(entity));
      } else {
        await _mhsRepo.createHabit(Habit.fromMap(entity));
      }
      setState(() {
        _loading = false;
        Navigator.of(context).pop();
      });
    } else {
      Fluttertoast.showToast(msg: 'Ada data yang belum diisi');
    }
  }

  Future<void> _pressHapus() async {
    if (widget.mhs == null) return;
    setState(() {
      _loading = true;
    });
    await _mhsRepo.deleteHabit(widget.mhs!);
    setState(() {
      _loading = false;
      Navigator.of(context).pop();
    });
  }

  List<InputModel> _generateModel() {
    return [
      InputModel(
        'Habit Name',
        InputType.text,
        field: columnHbName,
        controller: TextEditingController(),
        value: widget.mhs?.habitName ?? '',
      ),
      InputModel(
        'Habit Goal',
        InputType.text,
        field: columnGoal,
        controller: TextEditingController(),
        value: widget.mhs?.habitGoal ?? '',
      ),
      InputModel(
        '',
        InputType.button,
        buttons: [
          widget.isUpdate ? 'Update' : 'Tambah',
          if (widget.isUpdate) 'Hapus',
        ],
      ),
    ];
  }

  Widget _buildItem() {
    List<Widget> model = _models.map((InputModel e) {
      return InputModelView(
        model: e,
        onButtonPressed: _pressButton,
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        children: model,
      ),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: _buildItem(),
            ),
    );
  }
}
