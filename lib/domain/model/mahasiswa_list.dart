import 'package:uts_unsia/data/entity/nilai_entity.dart';
import 'package:uts_unsia/domain/model/mahasiswa.dart';

class MahasiswaList {
  late List<Mahasiswa> data;

  MahasiswaList({required this.data});

  MahasiswaList.fromMap(DataListEntity map) {
    data = map.map((e) => Mahasiswa.fromMap(e)).toList();
  }

  DataListEntity toMap() {
    List<DataEntity> list = [];
    for (var element in data) {
      list.add(element.toMap());
    }
    return list;
  }
}
