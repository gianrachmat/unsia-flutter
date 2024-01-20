import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uts_unsia/data/datasource/database/nilai_database_impl.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';
import 'package:uts_unsia/data/repository/nilai_repo_impl.dart';
import 'package:uts_unsia/domain/model/nilai.dart';
import 'package:uts_unsia/domain/repo/nilai_repo.dart';

class TambahListPage extends StatefulWidget {
  const TambahListPage({
    super.key,
    required this.title,
    this.isUpdate = false,
    this.nilai,
  });

  final String title;
  final bool isUpdate;
  final Nilai? nilai;

  @override
  State<TambahListPage> createState() => _TambahListPageState();
}

class _TambahListPageState extends State<TambahListPage> {
  final List<String> _radioItems = [
    'Sistem Informasi',
    'Informatika',
  ];
  late String _selectedRadio;
  final NilaiRepo _nilaiRepo = NilaiRepoImpl(NilaiDatabaseImpl());
  bool _loading = false;
  late List<InputModel> _models;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      _selectedRadio = widget.nilai?.prodi ?? _radioItems.first;
    } else {
      _selectedRadio = _radioItems.first;
    }
    _models = _generateModel();
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
    NilaiEntity entity = {};
    bool empty = false;
    if (widget.isUpdate) {
      entity.addAll(widget.nilai!.toMap());
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
        await _nilaiRepo.updateNilai(Nilai.fromMap(entity));
      } else {
        await _nilaiRepo.createNilai(Nilai.fromMap(entity));
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
    if (widget.nilai == null) return;
    setState(() {
      _loading = true;
    });
    await _nilaiRepo.deleteNilai(widget.nilai!);
    setState(() {
      _loading = false;
      Navigator.of(context).pop();
    });
  }

  List<InputModel> _generateModel() {
    return [
      InputModel('Program Hitung Nilai Akhir UNSIA', InputType.title),
      InputModel(
        'Nama',
        InputType.text,
        field: 'nama',
        controller: TextEditingController(),
        value: widget.nilai?.nama ?? '',
      ),
      InputModel(
        'NIM',
        InputType.text,
        field: 'nim',
        controller: TextEditingController(),
        value: widget.nilai?.nim ?? '',
      ),
      InputModel(
        'Prodi',
        InputType.radio,
        radioItem: _radioItems,
        field: 'prodi',
        value: widget.nilai?.prodi ?? '',
      ),
      InputModel(
        'Nilai Absen',
        InputType.number,
        field: 'nilaiAbsen',
        controller: TextEditingController(),
        value: "${widget.nilai?.nilaiAbsen ?? ''}",
      ),
      InputModel(
        'Nilai Tugas/Praktikum',
        InputType.number,
        field: 'nilaiTugas',
        controller: TextEditingController(),
        value: "${widget.nilai?.nilaiTugas ?? ''}",
      ),
      InputModel(
        'Nilai UTS',
        InputType.number,
        field: 'nilaiUTS',
        controller: TextEditingController(),
        value: "${widget.nilai?.nilaiUTS ?? ''}",
      ),
      InputModel(
        'Nilai UAS',
        InputType.number,
        field: 'nilaiUAS',
        controller: TextEditingController(),
        value: "${widget.nilai?.nilaiUAS ?? ''}",
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
      Widget item = Container();
      switch (e.type) {
        case InputType.title:
          item = Center(
            child: Text(
              e.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
          break;
        case InputType.text:
        case InputType.number:
          e.controller?.text = e.value;
          item = TextField(
            key: Key(e.title),
            controller: e.controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          );
          break;
        case InputType.radio:
          if (e.radioItem.isNotEmpty) {
            List<Widget> radios = [];
            for (var element in e.radioItem) {
              radios.add(
                Row(
                  children: [
                    Radio<String>(
                      value: element,
                      groupValue: _selectedRadio,
                      onChanged: (selected) {
                        setState(() {
                          _selectedRadio = selected ?? '';
                        });
                      },
                    ),
                    Text(element),
                  ],
                ),
              );
            }
            item = Column(children: radios);
          }
          break;
        case InputType.button:
          if (e.buttons.isNotEmpty) {
            List<Widget> buttons = [];
            for (var element in e.buttons) {
              buttons.add(OutlinedButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _pressButton(element),
                child: Text(element),
              ));
            }
            item = Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: buttons,
              ),
            );
          }
          break;
        default:
          item = Container();
          break;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            if (e.title != '' && e.type != InputType.title)
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Text(e.title),
              ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: item,
            ),
          ],
        ),
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

enum InputType { title, text, number, radio, button }

class InputModel {
  String title;
  String field;
  String value;
  InputType type;
  List<String> radioItem;
  List<String> buttons;
  TextEditingController? controller;

  InputModel(
    this.title,
    this.type, {
    this.field = '',
    this.value = '',
    this.radioItem = const [],
    this.buttons = const [],
    this.controller,
  });
}

bool isNumeric(String str) {
  RegExp numeric = RegExp(r'^-?[0-9]+$');
  return numeric.hasMatch(str);
}