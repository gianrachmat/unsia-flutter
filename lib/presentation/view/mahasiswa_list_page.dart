import 'package:flutter/material.dart';
import 'package:uts_unsia/data/datasource/database/mahasiswa_database_impl.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';
import 'package:uts_unsia/data/repository/mhs_repo_impl.dart';
import 'package:uts_unsia/domain/model/mahasiswa.dart';
import 'package:uts_unsia/domain/model/mahasiswa_list.dart';
import 'package:uts_unsia/domain/repo/mhs_repo.dart';
import 'package:uts_unsia/presentation/view/input_model_view.dart';
import 'package:uts_unsia/presentation/view/tambah_mahasiswa_page.dart';
import 'package:uts_unsia/presentation/view/tambah_nilai_page.dart';

class MahasiswaListPage extends StatefulWidget {
  const MahasiswaListPage({
    super.key,
    required this.title,
    this.isSelect = false,
  });

  final String title;
  final bool isSelect;

  @override
  State<MahasiswaListPage> createState() => _MahasiswaListPage();
}

class _MahasiswaListPage extends State<MahasiswaListPage> {
  final List<String> _radioItems = [
    'Sistem Informasi',
    'Informatika',
  ];
  late String _selectedRadio;
  final MhsRepo _mhsRepo = MhsRepoImpl(MahasiswaDatabaseImpl());
  MahasiswaList _mhsList = MahasiswaList(data: []);

  @override
  void initState() {
    super.initState();
    _selectedRadio = _radioItems.first;
    _getMhs();
  }

  Future<void> _getMhs() async {
    MahasiswaList mhsList = await _mhsRepo.getMhsList();
    setState(() {
      _mhsList = mhsList;
    });
  }

  Widget _buildItem() {
    return _mhsList.data.isEmpty
        ? const Center(child: Text('Belum ada data'))
        : ListView.builder(
            itemCount: _mhsList.data.length,
            itemBuilder: (context, i) {
              DataEntity mhs = _mhsList.data[i].toMap();
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
                      ? TambahListPage(
                          title: 'Tambah Nilai Mahasiswa',
                          mhs: Mahasiswa.fromMap(mhs),
                        )
                      : TambahMhsListPage(
                          title: 'Tambah Mahasiswa',
                          mhs: Mahasiswa.fromMap(mhs),
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
                    _getMhs();
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
              builder: (_) => const TambahMhsListPage(
                title: 'Tambah Mahasiswa',
              ),
            ),
          );
          _getMhs();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
