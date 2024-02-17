import 'package:uts_unsia/data/entity/nilai_entity.dart';
import 'package:uts_unsia/domain/model/nilai.dart';

class NilaiList {
  late List<Nilai> data;

  NilaiList({required this.data});

  NilaiList.fromMap(DataListEntity map) {
    data = map.map((e) => Nilai.fromMap(e)).toList();
  }

  DataListEntity toMap() {
    List<DataEntity> list = [];
    for (var element in data) {
      list.add(element.toMap());
    }
    return list;
  }
}