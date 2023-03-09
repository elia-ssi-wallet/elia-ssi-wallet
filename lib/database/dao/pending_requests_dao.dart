import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/database/tables/pending_requests_table.dart';

part 'pending_requests_dao.drift.dart';

@DriftAccessor(tables: [PendingRequests])
class PendingRequestsDao extends DatabaseAccessor<Database> with _$PendingRequestsDaoMixin {
  PendingRequestsDao(Database attachedDatabase) : super(attachedDatabase);

  Future<int> insertPendingRequests({required String serviceEndpoint, required dynamic vp}) async {
    PendingRequestsCompanion newPendingRequest = PendingRequestsCompanion.insert(
      serviceEndpoint: serviceEndpoint,
      vp: jsonEncode(vp),
    );

    return await into(pendingRequests).insert(newPendingRequest);
  }

  Future<void> updatePendingRequests({required int id, required dynamic vpVc}) async {
    PendingRequest pendingRequest = await getPendingRequestsWithId(id: id);

    PendingRequestsCompanion newPendingRequest = PendingRequestsCompanion.insert(
      id: Value(id),
      serviceEndpoint: pendingRequest.serviceEndpoint,
      vp: pendingRequest.vp,
      vpVc: Value(jsonEncode(vpVc)),
    );

    await into(pendingRequests).insertOnConflictUpdate(newPendingRequest);
  }

  Future<void> insertTestPendingRequests() async {
    PendingRequestsCompanion newPendingRequest = PendingRequestsCompanion.insert(
      serviceEndpoint: testServiceEndpoint,
      vp: jsonEncode(testvp),
    );

    await into(pendingRequests).insert(newPendingRequest);
  }

  Future<void> updatePendingRequest({required int id, required dynamic vc}) async {
    (update(pendingRequests)
      ..where((tbl) => tbl.id.equals(id))
      ..write(
        PendingRequestsCompanion(vpVc: Value(jsonEncode(vc))),
      ));
  }

  Future<void> updatePendingRequestWithError({required int id}) async {
    (update(pendingRequests)
      ..where((tbl) => tbl.id.equals(id))
      ..write(
        const PendingRequestsCompanion(error: Value(true)),
      ));
  }

  Future<void> deletePendingRequests() => delete(pendingRequests).go();

  Future<void> deletePendingRequest({required dynamic vp}) => (delete(pendingRequests)..where((tbl) => tbl.vpVc.equals(jsonEncode(vp)))).go();

  Future<void> deletePendingRequestWithId({required int id}) => (delete(pendingRequests)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<PendingRequest>> getPendingRequests() => select(pendingRequests).get();

  Stream<List<PendingRequest>> requestsStream() => select(pendingRequests).watch();

  Stream<List<PendingRequest>> pendingRequestsStream() => (select(pendingRequests)..where((tbl) => tbl.vpVc.isNull())).watch();

  Future<PendingRequest> getPendingRequestsWithId({required int id}) => (select(pendingRequests)
        ..where((tbl) => tbl.id.equals(id))
        ..limit(1))
      .getSingle();
}

String testServiceEndpoint = "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test";

dynamic testvp = {
  "@context": ["https://www.w3.org/2018/credentials/v1"],
  "type": "VerifiablePresentation",
  "proof": {
    "type": "Ed25519Signature2018",
    "proofPurpose": "authentication",
    "challenge": "deda8d6e-c4d1-44cf-ba90-628a736ff29b",
    "verificationMethod": "did:key:z6MkpvchYYdazv5nxdgzKAjs6kH4CrTpSyprxx8ABRFcxUNA#z6MkpvchYYdazv5nxdgzKAjs6kH4CrTpSyprxx8ABRFcxUNA",
    "created": "2023-01-18T10:30:44.988Z",
    "jws": "eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..geKwdwg5njE47U8p446kcXqImioO-fnAQ1-PsiLOgeMojgYJKeqHEzio6h45ykwkAYxr53H9NUAmboYwbYPKAA"
  },
  "holder": "did:key:z6MkpvchYYdazv5nxdgzKAjs6kH4CrTpSyprxx8ABRFcxUNA"
};
