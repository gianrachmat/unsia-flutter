import 'package:uts_unsia/domain/model/nilai.dart';
import 'package:uts_unsia/domain/model/nilai_list.dart';

abstract class NilaiRepo {
  Future<NilaiList> getNilaiList();
  Future<Nilai> createNilai(Nilai nilai);
  Future<void> updateNilai(Nilai nilai);
  Future<void> deleteNilai(final Nilai nilai);
}