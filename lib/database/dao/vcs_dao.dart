import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/database/tables/vcs_table.dart';

part 'vcs_dao.drift.dart';

@DriftAccessor(tables: [VCs])
class VCsDao extends DatabaseAccessor<Database> with _$VCsDaoMixin {
  VCsDao(Database attachedDatabase) : super(attachedDatabase);

  Future<void> insertVCs({required dynamic vc, required String label}) async {
    VCsCompanion newVC = VCsCompanion.insert(
      label: label,
      vc: jsonEncode(vc),
    );

    await into(vCs).insert(newVC);
  }

  Future<void> deleteVCs() => delete(vCs).go();

  Future<void> deleteVC({required int vcId}) => (delete(vCs)..where((tbl) => tbl.id.equals(vcId))).go();

  Future<List<VC>> getVCs() => select(vCs).get();

  Stream<List<VC>> vCsStream() => select(vCs).watch();
}
