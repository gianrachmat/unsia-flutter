import 'package:uts_unsia/data/entity/nilai_entity.dart';

abstract class NilaiDatabase {
  Future<NilaiListEntity> allNilai();
  Future<NilaiEntity> insertNilai(final NilaiEntity entity);
  Future<void> updateNilai(final NilaiEntity entity);
  Future<void> deleteNilai(final int id);
}