import 'package:flutter/material.dart';
import 'package:uts_unsia/data/datasource/database/nilai_database_impl.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';
import 'package:uts_unsia/data/repository/nilai_repo_impl.dart';
import 'package:uts_unsia/domain/model/nilai.dart';
import 'package:uts_unsia/domain/model/nilai_list.dart';
import 'package:uts_unsia/domain/repo/nilai_repo.dart';
import 'package:uts_unsia/presentation/view/tambah_nilai_page.dart';

class NilaiListPage extends StatefulWidget {
  const NilaiListPage({super.key, required this.title});

  final String title;

  @override
  State<NilaiListPage> createState() => _NilaiListPageState();
}

class _NilaiListPageState extends State<NilaiListPage> {
  final List<String> _radioItems = [
    'Sistem Informasi',
    'Informatika',
  ];
  late String _selectedRadio;
  final NilaiRepo _nilaiRepo = NilaiRepoImpl(NilaiDatabaseImpl());
  NilaiList _nilaiList = NilaiList(data: []);

  @override
  void initState() {
    super.initState();
    _selectedRadio = _radioItems.first;
    _getNilai();
  }

  Future<void> _getNilai() async {
    NilaiList nilaiList = await _nilaiRepo.getNilaiList();
    setState(() {
      _nilaiList = nilaiList;
    });
  }

  Widget _buildItem() {
    return _nilaiList.data.isEmpty
        ? const Center(child: Text('Belum ada data'))
        : ListView.builder(
            itemCount: _nilaiList.data.length,
            itemBuilder: (context, i) {
              NilaiEntity nilai = _nilaiList.data[i].toMap();
              List<Widget> children = [];
              nilai.forEach((key, value) {
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
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TambahListPage(
                        title: 'Tambah Nilai',
                        isUpdate: true,
                        nilai: Nilai.fromMap(nilai),
                      ),
                    ),
                  );
                  _getNilai();
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
              builder: (_) => const TambahListPage(
                title: 'Tambah Nilai',
              ),
            ),
          );
          _getNilai();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
