import 'package:uts_unsia/data/entity/nilai_entity.dart';

abstract class MahasiswaDatabase {
  Future<DataListEntity> allMahasiswa();
  Future<DataEntity> insertMahasiswa(final DataEntity entity);
  Future<void> updateMahasiswa(final DataEntity entity);
  Future<void> deleteMahasiswa(final int? id);
}