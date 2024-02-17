import 'package:uts_unsia/data/entity/nilai_entity.dart';

abstract class NilaiDatabase {
  Future<DataListEntity> allNilai();
  Future<DataEntity> insertNilai(final DataEntity entity);
  Future<void> updateNilai(final DataEntity entity);
  Future<void> deleteNilai(final int? id);
}