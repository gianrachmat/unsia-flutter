import 'package:flutter/foundation.dart';
import 'package:uts_unsia/data/entity/nilai_entity.dart';

class Mahasiswa {
  late int? id;
  late String nama;
  late String prodi;
  late String nim;

  Mahasiswa({
    required id,
    required nama,
    required prodi,
    required nimrequired,
  });

  Mahasiswa.fromMap(DataEntity map) {
    debugPrint('map mhs $map');
    id = map['mhsId'] ?? map['id'];
    nama = map['nama'];
    prodi = map['prodi'];
    nim = map['nim'];
  }

  DataEntity toMap() {
    DataEntity data = {};
    data['id'] = id;
    data['nama'] = nama;
    data['prodi'] = prodi;
    data['nim'] = nim;

    return data;
  }
}
