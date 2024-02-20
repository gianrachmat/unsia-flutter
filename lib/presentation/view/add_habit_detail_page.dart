import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uts_unsia/data/datasource/database/habit_database_impl.dart';
import 'package:uts_unsia/data/datasource/database/habit_detail_database_impl.dart';
import 'package:uts_unsia/data/entity/data_entity.dart';
import 'package:uts_unsia/data/repository/habit_detail_repo_impl.dart';
import 'package:uts_unsia/domain/model/habit.dart';
import 'package:uts_unsia/domain/model/habit_detail.dart';
import 'package:uts_unsia/domain/repo/habit_detail_repo.dart';
import 'package:uts_unsia/helper/utils.dart';
import 'package:uts_unsia/presentation/view/input_model_view.dart';

class AddHabitDetailPage extends StatefulWidget {
  const AddHabitDetailPage({
    super.key,
    required this.title,
    this.isUpdate = false,
    this.habitDetail,
    this.habit,
  });

  final String title;
  final bool isUpdate;
  final HabitDetail? habitDetail;
  final Habit? habit;

  @override
  State<AddHabitDetailPage> createState() => _AddHabitDetailPageState();
}

class _AddHabitDetailPageState extends State<AddHabitDetailPage> {
  final HabitDetailRepo _nilaiRepo = HabitDetailRepoImpl(HabitDetailDatabaseImpl());
  bool _loading = false;
  late List<InputModel> _models;

  @override
  void initState() {
    super.initState();
    _models = _generateModel();
    debugPrint('${widget.habit?.toMap()}');
  }

  void _pressButton(String button) {
    switch (button) {
      case 'Update':
        _pressTambah();
        break;
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
      entity.addAll(widget.habitDetail!.toMap());
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
            String text;
            if (im.field == columnHabitDate) {
              text = getDate();
            } else {
              text = im.controller!.text;
            }
            entity[im.field] = text;
          }
        }
      }
    }
    if (widget.habit != null) {
      entity[columnHabitId] = widget.habit?.id;
    }
    debugPrint('$runtimeType entity $entity');
    if (!empty) {
      setState(() {
        _loading = true;
      });
      if (widget.isUpdate) {
        await _nilaiRepo.updateHabitDetail(HabitDetail.fromMap(entity));
      } else {
        await _nilaiRepo.createHabitDetail(HabitDetail.fromMap(entity));
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
    if (widget.habitDetail == null) return;
    setState(() {
      _loading = true;
    });
    await _nilaiRepo.deleteHabitDetail(widget.habitDetail!);
    setState(() {
      _loading = false;
      Navigator.of(context).pop();
    });
  }

  List<InputModel> _generateModel() {
    String date = "${widget.habitDetail != null ? widget.habitDetail?.habitDate : getDate()}";
    date = toEDMY(date);
    return [
      InputModel(
        'Habit Name',
        InputType.text,
        readOnly: true,
        controller: TextEditingController(),
        field: columnHbName,
        value: widget.habit?.habitName ??
            widget.habitDetail?.habit.habitName ??
            '',
      ),
      InputModel(
        'Habit Goal',
        InputType.text,
        readOnly: true,
        controller: TextEditingController(),
        field: columnGoal,
        value: widget.habit?.habitGoal ??
            widget.habitDetail?.habit.habitGoal ??
            '',
      ),
      InputModel(
        'Habit Date',
        InputType.text,
        field: columnHabitDate,
        readOnly: true,
        controller: TextEditingController(),
        value: date,
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
      child: Column(children: model),
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
