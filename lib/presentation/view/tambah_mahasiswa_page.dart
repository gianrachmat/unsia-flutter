import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uts_unsia/data/datasource/database/mahasiswa_database_impl.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';
import 'package:uts_unsia/data/repository/mhs_repo_impl.dart';
import 'package:uts_unsia/domain/model/mahasiswa.dart';
import 'package:uts_unsia/domain/repo/mhs_repo.dart';
import 'package:uts_unsia/presentation/view/input_model_view.dart';

class TambahMhsListPage extends StatefulWidget {
  const TambahMhsListPage({
    super.key,
    required this.title,
    this.isUpdate = false,
    this.mhs,
    this.isSelect = false,
  });

  final String title;
  final bool isUpdate;
  final Mahasiswa? mhs;
  final bool isSelect;

  @override
  State<TambahMhsListPage> createState() => _TambahMhsListPageState();
}

class _TambahMhsListPageState extends State<TambahMhsListPage> {
  final List<String> _radioItems = [
    'Sistem Informasi',
    'Informatika',
  ];
  late String _selectedRadio;
  final MhsRepo _mhsRepo = MhsRepoImpl(MahasiswaDatabaseImpl());
  bool _loading = false;
  late List<InputModel> _models;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      _selectedRadio = widget.mhs?.prodi ?? _radioItems.first;
    } else {
      _selectedRadio = _radioItems.first;
    }
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
      if (im.type == InputType.radio) {
        entity[im.field] = _selectedRadio;
      }
    }
    if (!empty) {
      setState(() {
        _loading = true;
      });
      if (widget.isUpdate) {
        await _mhsRepo.updateMhs(Mahasiswa.fromMap(entity));
      } else {
        await _mhsRepo.createMhs(Mahasiswa.fromMap(entity));
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
    await _mhsRepo.deleteMhs(widget.mhs!);
    setState(() {
      _loading = false;
      Navigator.of(context).pop();
    });
  }

  List<InputModel> _generateModel() {
    return [
      InputModel(
        'Nama',
        InputType.text,
        field: 'nama',
        controller: TextEditingController(),
        value: widget.mhs?.nama ?? '',
      ),
      InputModel(
        'NIM',
        InputType.text,
        field: 'nim',
        controller: TextEditingController(),
        value: widget.mhs?.nim ?? '',
      ),
      InputModel(
        'Prodi',
        InputType.radio,
        radioItem: _radioItems,
        field: 'prodi',
        value: widget.mhs?.prodi ?? '',
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
        selectedRadio: _selectedRadio,
        onRadioChanged: (selected) {
          _selectedRadio = selected ?? '';
        },
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
