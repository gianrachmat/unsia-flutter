import 'package:uts_unsia/data/datasource/database/mahasiswa_database.dart';
import 'package:uts_unsia/domain/model/mahasiswa.dart';
import 'package:uts_unsia/domain/model/mahasiswa_list.dart';
import 'package:uts_unsia/domain/repo/mhs_repo.dart';

class MhsRepoImpl implements MhsRepo {
  final MahasiswaDatabase database;

  const MhsRepoImpl(this.database);

  @override
  Future<Mahasiswa> createMhs(Mahasiswa mhs) async {
    final mhsEntity = await database.insertMahasiswa(mhs.toMap());
    return Mahasiswa.fromMap(mhsEntity);
  }

  @override
  Future<void> deleteMhs(Mahasiswa mhs) async {
    await database.deleteMahasiswa(mhs.id);
  }

  @override
  Future<MahasiswaList> getMhsList() async {
    final mhsListEntity = await database.allMahasiswa();
    return MahasiswaList.fromMap(mhsListEntity);
  }

  @override
  Future<void> updateMhs(Mahasiswa mhs) async {
    await database.updateMahasiswa(mhs.toMap());
  }

}