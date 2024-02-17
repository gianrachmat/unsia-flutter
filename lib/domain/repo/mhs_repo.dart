import 'package:uts_unsia/domain/model/mahasiswa.dart';
import 'package:uts_unsia/domain/model/mahasiswa_list.dart';

abstract class MhsRepo {
  Future<MahasiswaList> getMhsList();
  Future<Mahasiswa> createMhs(Mahasiswa mhs);
  Future<void> updateMhs(Mahasiswa mhs);
  Future<void> deleteMhs(final Mahasiswa mhs);
}