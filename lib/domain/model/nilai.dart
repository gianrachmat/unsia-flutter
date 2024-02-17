import 'package:uts_unsia/data/entity/nilai_entity.dart';

import 'mahasiswa.dart';

class Nilai {
  late int? id;
  late Mahasiswa mhs;
  late int nilaiAbsen;
  late int nilaiTugas;
  late int nilaiUTS;
  late int nilaiUAS;

  Nilai({
    required this.id,
    required this.mhs,
    required this.nilaiAbsen,
    required this.nilaiTugas,
    required this.nilaiUTS,
    required this.nilaiUAS,
  });

  Nilai.fromMap(DataEntity map) {
    id = map['id'];
    mhs = Mahasiswa.fromMap(map);
    nilaiAbsen = map['nilaiAbsen'];
    nilaiTugas = map['nilaiTugas'];
    nilaiUTS = map['nilaiUTS'];
    nilaiUAS = map['nilaiUAS'];
  }

  Map<String, dynamic> toMap({bool insert = false}) {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['mhsId'] = mhs.id;
    if (!insert) {
      map['nama'] = mhs.nama;
      map['prodi'] = mhs.prodi;
      map['nim'] = mhs.nim;
    }
    map['nilaiAbsen'] = nilaiAbsen;
    map['nilaiTugas'] = nilaiTugas;
    map['nilaiUTS'] = nilaiUTS;
    map['nilaiUAS'] = nilaiUAS;

    return map;
  }
}
