import 'package:uts_unsia/data/entity/nilai_entity.dart';

class Nilai {
  late int id;
  late String nama;
  late String nim;
  late String prodi;
  late int nilaiAbsen;
  late int nilaiTugas;
  late int nilaiUTS;
  late int nilaiUAS;

  Nilai({
    required this.id,
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.nilaiAbsen,
    required this.nilaiTugas,
    required this.nilaiUTS,
    required this.nilaiUAS,
  });

  Nilai.fromMap(NilaiEntity map) {
    id = map['id'];
    nama = map['nama'];
    nim = map['nim'];
    prodi = map['prodi'];
    nilaiAbsen = map['nilaiAbsen'];
    nilaiTugas = map['nilaiTugas'];
    nilaiUTS = map['nilaiUTS'];
    nilaiUAS = map['nilaiUAS'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['nama'] = nama;
    map['nim'] = nim;
    map['prodi'] = prodi;
    map['nilaiAbsen'] = nilaiAbsen;
    map['nilaiTugas'] = nilaiTugas;
    map['nilaiUTS'] = nilaiUTS;
    map['nilaiUAS'] = nilaiUAS;

    return map;
  }
}
